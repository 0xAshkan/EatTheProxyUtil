#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Get username
UNAME=$(logname)

# Check running privilege
if [ "$EUID" -ne 0 ]; then
	echo -e "$RED[-] RUN WITH ROOT PRIVILEGE!$RESET"
	exit 1
fi

# Installing v2ray
V_INSTALL=$(curl -L -s https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh | bash 2> /dev/null)
if [ "$?" -eq 0 ]; then
	if echo "$V_INSTALL" | grep -q 'No new version'; then
		echo -e "$YELLOW[~] NO NEW VERSION AVAILABLE FOR V2RAY."
	else
		echo -e "$GREEN[+] V2RAY INSTALLED SUECCESSFULLY!$RESET"
	fi
else
	echo -e "$RED[-] AN ERROR OCCURED DURING INSTALLING V2RAY!$RESET"
	exit 1
fi

# Installing xray
X_INSTALL=$(curl -s -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh  | bash 2> /dev/null)
if [ "$?" -eq 0 ]; then
	if echo "$X_INSTALL" | grep -q 'No new version'; then
		echo -e "$YELLOW[~] NO NEW VERSION AVAILABLE FOR XRAY.$RESET"
	else
		echo -e "$GREEN[+] XRAY INSTALLED SUCCESSFULLY!$RESET"
	fi
else
	echo -e "$RED[-] AN ERROR OCCURED DURING INSTALLING XRAY!$RESET"
	exit 1
fi

# Installing proxyutil & python3 & pip3
if command -v python3 &> /dev/null ; then
	if command -v pip3 &> /dev/null; then
		PU_INSTALL=$(python3 -m pip install --user $UNAME --upgrade git+https://github.com/mheidari98/proxyUtil@main &>/dev/null)
		if [ "$?" -eq 0 ]; then
			echo -e "$GREEN[+] PROXYUTIL INSTALLED SUCCESSFULLY!"
		else
			echo -e "$RED[-] AN ERROR OCCURED DURING INSTALLING PROXYUTIL!$RESET"
			exit 1
		fi
	else
		apt-get install -y python3-pip
	fi
else
	apt install -y python3
fi

cp ./MakeItEasier/vcRunner.sh /usr/local/bin/

echo -e "\e[1;92mNOW YOU CAN CHECK FOR CONFIGS WITH THIS COMMANDS: \e[0m\e[97;4mvcRunner.sh\e[0m"
