echo -e "\033[0;100m $(lsb_release -d -s) \n\033[0;42m $(uname -s -r) \n\033[0;104m $(dpkg -l | grep -c '^ii') packages \n\033[0;41m $(df -h / | awk 'NR==2 {printf "%s/%s (%s)\n", $3, $2, $5}') \n"
