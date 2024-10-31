#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
RESET='\033[0m'

log() {
    local type="$1"
    local message="$2"
    local color="$3"
    echo -e "${color}[$type] $message${RESET}"
}

UNAME=${SUDO_USER:-$(whoami)}

if [ "$EUID" -ne 0 ]; then
    log "ERROR" "Run the script with root privileges." "$RED"
    exit 1
fi

log "INFO" "Starting installation script." "$BLUE"

install_v2ray() {
    log "INFO" "Downloading V2Ray installation script..." "$BLUE"
    curl -L -s -o install-v2ray.sh https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
    log "INFO" "Running V2Ray installation script." "$BLUE"
    V_INSTALL=$(bash install-v2ray.sh 2>/dev/null)
    rm -f install-v2ray.sh
    
    if [ "$?" -eq 0 ]; then
        if echo "$V_INSTALL" | grep -q 'No new version'; then
            log "WARNING" "No new version available for V2Ray." "$YELLOW"
        else
            log "SUCCESS" "V2Ray installed successfully." "$GREEN"
        fi
    else
        log "ERROR" "An error occurred during V2Ray installation." "$RED"
        exit 1
    fi
}

install_xray() {
    log "INFO" "Downloading Xray installation script..." "$BLUE"
    curl -s -L -o install-xray.sh https://github.com/XTLS/Xray-install/raw/main/install-release.sh
    log "INFO" "Running Xray installation script." "$BLUE"
    X_INSTALL=$(bash install-xray.sh 2>/dev/null)
    rm -f install-xray.sh

    if [ "$?" -eq 0 ]; then
        if echo "$X_INSTALL" | grep -q 'No new version'; then
            log "WARNING" "No new version available for Xray." "$YELLOW"
        else
            log "SUCCESS" "Xray installed successfully." "$GREEN"
        fi
    else
        log "ERROR" "An error occurred during Xray installation." "$RED"
        exit 1
    fi
}

install_proxyutil() {
    if ! command -v python3 &>/dev/null; then
        log "INFO" "Installing Python3..." "$BLUE"
        sudo apt-get install -y python3
    fi

    log "INFO" "Installing virtualenv" "$BLUE"
    pip install --break-system-packages --upgrade virtualenv
    log "INFO" "Creating a virtual environment '/opt/ETPU'..." "$BLUE"
    sudo virtualenv /opt/ETPU

    log "INFO" "Activating virtual environment and installing setuptools and distutils..." "$BLUE"
    source /opt/ETPU/bin/activate

    if pip install setuptools && pip install git+https://github.com/pypa/distutils.git; then
        log "SUCCESS" "setuptools and distutils installed successfully in '/opt/ETPU'." "$GREEN"
    else
        log "ERROR" "Failed to install setuptools or distutils." "$RED"
        deactivate
        exit 1
    fi

    log "INFO" "Installing proxyUtil in the virtual environment..." "$BLUE"
    if pip install git+https://github.com/mheidari98/proxyUtil@main; then
        log "SUCCESS" "proxyUtil installed successfully in the virtual environment." "$GREEN"
    else
        log "ERROR" "An error occurred during proxyUtil installation." "$RED"
        deactivate
        exit 1
    fi

    deactivate
    log "INFO" "Virtual environment setup completed." "$BLUE"
}

install_v2ray
install_xray
install_proxyutil

if cp ./MakeItEasier/vcRunner.sh /usr/local/bin/; then
    log "SUCCESS" "vcRunner.sh copied to /usr/local/bin successfully." "$GREEN"
    log "INFO" "You can run the tool using command: vcRunner.sh" "$BLUE"
else
    log "ERROR" "Failed to copy vcRunner.sh to /usr/local/bin." "$RED"
    exit 1
fi

log "INFO" "Installation script completed." "$BLUE"
