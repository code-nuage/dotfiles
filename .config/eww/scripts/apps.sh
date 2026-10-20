#!/bin/bash
# App launcher backend.
# Scans .desktop entries from user, flatpak (user + system) and system dirs,
# caches them as JSON and launches apps via gtk-launch.
#
# Usage:
#   apps.sh list              # print cached app list as JSON
#   apps.sh filter "<query>"  # update the `filtered` eww var with matches
#   apps.sh accept "<query>"  # launch the best match for query
#   apps.sh launch "<id>"     # launch a desktop file id (e.g. firefox.desktop)
#   apps.sh toggle            # open/close the launcher window (resets search)

set -u

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/eww"
CACHE="$CACHE_DIR/apps.json"
CACHE_TTL=300 # seconds

# XDG precedence: user > user flatpak > system flatpak > local > system
APP_DIRS=(
	"$HOME/.local/share/applications"
	"$HOME/.local/share/flatpak/exports/share/applications"
	"/var/lib/flatpak/exports/share/applications"
	"/usr/local/share/applications"
	"/usr/share/applications"
)

ICON_DIRS=(
	"$HOME/.local/share/icons"
	"$HOME/.local/share/flatpak/exports/share/icons"
	"/var/lib/flatpak/exports/share/icons"
	"/usr/local/share/icons"
	"/usr/share/icons"
	"/usr/share/pixmaps"
)

json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

find_icon() {
	local icon="$1" d
	[ -n "$icon" ] || return 0
	# absolute path in the entry itself
	if [ "${icon#/}" != "$icon" ]; then
		[ -f "$icon" ] && printf '%s' "$icon"
		return 0
	fi
	# prefer scalable svg, then largest raster sizes
	local found
	found=$(find "${ICON_DIRS[@]}" \( -type f -o -type l \) -path "*/apps/*" -name "$icon.svg" 2>/dev/null | sort | head -1)
	if [ -z "$found" ]; then
		found=$(find "${ICON_DIRS[@]}" \( -type f -o -type l \) \( -path "*/apps/*" -o -path "*/pixmaps/*" \) \
			\( -name "$icon.png" -o -name "$icon.xpm" \) 2>/dev/null | sort -r | head -1)
	fi
	printf '%s' "$found"
}

# parse a .desktop file -> emits "id\tname\tgeneric\ticon\tpath\tterminal"
parse_desktop() {
	local file="$1" id name="" generic="" icon="" terminal="false"
	local type="" hidden="false" nodisplay="false" only="" notin="" tryexec=""
	local line key val in_actions=false

	id="${file#*/applications/}"
	id="${id//\//-}" # subdir paths use - as separator in desktop ids

	while IFS= read -r line || [ -n "$line" ]; do
		case "$line" in
		"["*)
			# only the main entry matters, skip Actions/Desktop Actions etc.
			[ "$in_actions" = true ] && break
			[ "$line" != "[Desktop Entry]" ] && in_actions=true
			;;
		\#*) ;;
		*=*)
			key="${line%%=*}"
			val="${line#*=}"
			case "$key" in
			Type) type="$val" ;;
			Name) name="${name:-$val}" ;;
			GenericName) generic="$val" ;;
			Icon) icon="$val" ;;
			Terminal) terminal="$val" ;;
			Hidden) hidden="$val" ;;
			NoDisplay) nodisplay="$val" ;;
			OnlyShowIn) only="$val" ;;
			NotShowIn) notin="$val" ;;
			TryExec) tryexec="$val" ;;
			esac
			;;
		esac
	done <"$file"

	[ "$type" = "Application" ] || return 0
	if [ "$hidden" = "true" ] || [ "$nodisplay" = "true" ]; then return 0; fi
	[ -n "$name" ] || return 0

	# visibility per current desktop
	local desk="${XDG_CURRENT_DESKTOP:-}"
	if [ -n "$desk" ]; then
		local d matched
		if [ -n "$only" ]; then
			matched=false
			for d in "${desk//:/ }"; do
				case ";$only;" in *";$d;"*) matched=true ;; esac
			done
			[ "$matched" = true ] || return 0
		fi
		if [ -n "$notin" ]; then
			for d in "${desk//:/ }"; do
				case ";$notin;" in *";$d;"*) return 0 ;; esac
			done
		fi
	fi

	if [ -n "$tryexec" ]; then
		if [ "${tryexec#/}" = "$tryexec" ]; then
			command -v "$tryexec" >/dev/null 2>&1 || return 0
		else
			[ -x "$tryexec" ] || return 0
		fi
	fi

	printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
		"$(json_escape "$id")" \
		"$(json_escape "$name")" \
		"$(json_escape "$generic")" \
		"$(json_escape "$icon")" \
		"$(json_escape "$(find_icon "$icon")")" \
		"$terminal"
}

build_cache() {
	mkdir -p "$CACHE_DIR"
	local tmp raw
	tmp=$(mktemp)
	raw=$(mktemp)

	local dir f
	for dir in "${APP_DIRS[@]}"; do
		[ -d "$dir" ] || continue
		while IFS= read -r -d '' f; do
			parse_desktop "$f"
		done < <(find "$dir" \( -type f -o -type l \) -name '*.desktop' -print0 2>/dev/null)
	done >"$raw"

	# TSV -> JSON, dedupe by name (keeps higher-precedence dir, already sorted by input order)
	awk -F'\t' 'NF >= 6 {
		printf "{\"id\":\"%s\",\"name\":\"%s\",\"generic\":\"%s\",\"icon\":\"%s\",\"icon_path\":\"%s\",\"terminal\":%s}\n", $1, $2, $3, $4, $5, ($6 == "true" ? "true" : "false")
	}' "$raw" | jq -sc 'group_by(.name | ascii_downcase) | map(.[0]) | sort_by(.name | ascii_downcase)' >"$tmp"

	mv "$tmp" "$CACHE"
	rm -f "$raw"
}

ensure_cache() {
	if [ ! -f "$CACHE" ] || [ $(( $(date +%s) - $(stat -c %Y "$CACHE") )) -ge $CACHE_TTL ]; then
		build_cache
	fi
}

launch() {
	local id="${1%.desktop}"
	local term
	term=$(jq -r --arg id "$1" '.[] | select(.id == ($id + ".desktop")) | .terminal' "$CACHE" 2>/dev/null | head -1)

	if [ "$term" = "true" ]; then
		local t
		for t in "$TERMINAL" ghostty alacritty kitty foot wezterm xterm; do
			if [ -n "$t" ] && command -v "$t" >/dev/null 2>&1; then
				"$t" -e gtk-launch "$id" >/dev/null 2>&1 &
				return 0
			fi
		done
	fi
	gtk-launch "$id" >/dev/null 2>&1 &
}

filter_json() {
	local q
	q=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
	jq --arg q "$q" '[.[] | select(
		(.name | ascii_downcase | contains($q))
		or ((.generic // "") | ascii_downcase | contains($q))
		or (.id | ascii_downcase | contains($q))
	)]' "$CACHE"
}

case "${1:-}" in
list)
	ensure_cache
	cat "$CACHE"
	;;
filter)
	ensure_cache
	eww update filtered="$(filter_json "${2:-}")"
	;;
accept)
	ensure_cache
	first=$(filter_json "${2:-}" | jq -r '.[0].id // empty')
	[ -n "$first" ] && launch "$first"
	;;
launch)
	ensure_cache
	launch "${2:-}"
	;;
toggle)
	if eww active-windows | grep -q "^launcher:"; then
		eww close launcher
	else
		ensure_cache
		eww update filtered="$(cat "$CACHE")"
		eww open launcher
	fi
	;;
*)
	echo "usage: apps.sh {list|filter|accept|launch|toggle}" >&2
	exit 1
	;;
esac
