#!/bin/bash

windows=$(eww active-windows)

target="$1"

if echo "$windows" | grep -q "$target"; then
	eww close "$target"
else
	eww open "$target"
fi
