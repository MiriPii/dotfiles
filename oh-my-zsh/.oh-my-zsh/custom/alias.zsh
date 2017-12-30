##################
##  MY ALIASES  ##
##################

# ZSH
alias zrc="atom ~/.zshrc"
alias zre="source ~/.zshrc"
alias bk="cd $OLDPWD" # Go back to prev folder

# Browser
alias web="google-chrome"

# Connect to AirVPN Europe servers (prevents dns-leaks)
alias vpn="openvpn --config ~/.ovpn-files/AirVPN_Europe_TCP-443.ovpn"

# Network
alias ping="ping -c 5"

########################
# Lazy bum commands... #
########################

# Terminal Calculator
calc() { awk "BEGIN{ print $* }" ;}

# Install #
function install {
	sudo apt-get install $1
}

# -----------------------------------------------------------------------
####  SAFE KEEPING  ####
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

###### END OF ALIASES ######
