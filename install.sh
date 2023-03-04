#!/usr/bin/env bash

##
# Include
##

source ./colors.sh
source ./zsh/zshenv

##
# Screen
##

echo -e "
${magenta}-----------------------------
${red}Welcome to Omgeta's dotfiles
${magenta}-----------------------------"
echo -e "${red}!WARNING! ${yellow}Your existing config files will be overwritten ${red}!WARNING!"


if [ $# -ne 1 ] || [ "$1" != "-y" ] 
then
        echo -e "${yellow}Press a key to continue...\n"
        read key
else
	exit 1
fi

##
# Install
##
dot_install() {
	echo -e "${blue}-> Installing ${yellow}${1} ${blue}config"
	. "$DOTFILES/install/install-${1}.sh"
}

dot_install zsh
dot_install git
dot_install tmux
dot_install nvim
