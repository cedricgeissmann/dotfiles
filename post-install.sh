#! /usr/bin/env bash

# Call this script after installing Arch-Linux onto a new system. The script
# should setup everything else that we need for a good working environment

set -e

setup-dirs() {
    echo -e "\nSetting up direcories that are needed.\n"
    mkdir -p ${HOME}/.local/share/gnupg
    # Muss noch die richtigen Berechtigungen dafür setzen
    chmod 700 ${HOME}/.local/share/gnupg
    # chmod 600 ${HOME}/.local/share/gnupg/*
    chown -R ${USER}:${USER} ${HOME}/.local/share/gnupg

    # Das braucht es damit es eine history in zsh hat.
    # mkdir -p ${HOME}/.local/share/zsh

    # mkdir -p ${HOME}/.local/share/nvim/site
    echo -e "\nDone setting up all the directories.\n"
}

get-package-list() {
    cat package-list.txt
}

get-aur-package-list() {
    cat package-list-aur.txt
}

install-packages() {
    echo -e "\nInstalling all additional packages.\n"
    sudo pacman -Sy $(get-package-list)
    yay -Sy $(get-aur-package-list)
    echo -e "\nDone installing additional packages.\n"
}

stow-all() {
    echo -e "\nLinking all the config files.\n"
    stow alacritty
    stow dunst
    stow hyprland
    stow kitty
    stow waybar
    stow wofi
    echo -e "\nDone linking all the config files.\n"
}

setup-shell() {
    echo -e "\nSetting up zsh as the default shell for ${USER}\n"
    chsh -s $(which zsh)
    echo -e "\nDone setting up the shell.\n"
}

install-yay() {
    echo -e "\nInstalling yay from source...\n"
    local yaydir="/tmp/yay/"
    if [ -d "${yaydir}" ]; then
        echo "${yaydir} already exists. So yay is probably already installed."
    else
        git clone https://aur.archlinux.org/yay ${yaydir}
        cd ${yaydir}
        makepkg -si
        cd -
    fi
    echo -e "\nDone installing yay.\n"
}

setup-dirs
install-yay
install-packages
stow-all
# setup-shell

exit 0
