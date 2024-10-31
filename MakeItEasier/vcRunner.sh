#!/bin/bash

case "$@" in 
	"--help" | "-h")
        echo -e "\e[0;33mNo other settings are required!"
        echo -e "\e[0;33mJust run \e[4;3;97mvcRunner.sh\e[0m\n"
		exit
	;;
esac

RANDOM_NUMBER="$RANDOM$RANDOM$RANDOM"
if [ ! -d "$HOME/v2ray_configs" ]; then
	mkdir $HOME/v2ray_configs
fi
FULL_PATH="$HOME/v2ray_configs/configs_$RANDOM_NUMBER.txt"

source /opt/ETPU/bin/activate

v2rayChecker -v -T 100 --url 'https://raw.githubusercontent.com/mheidari98/.proxy/main/all' -o "$FULL_PATH" 

deactivate

echo -e "\n[+] CONFIGS SAVED TO '$FULL_PATH'."

