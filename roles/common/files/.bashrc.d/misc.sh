#!/bin/bash

######### exports #########
export EDITOR="$(which vim)"
######### exports #########

######### shell evals ########
eval "$(starship init bash)"
######### shell evals ########

######### alias ########
alias a=ansible
alias ap=ansible-playbook

alias p=podman

alias k=kubectl
######### alias ########

######### functions ########
# extract archives
# usage: extract <file>
extract() {
	if [ -f "$1" ] ; then
		case "$1" in
			*.tar) 
				tar xf "$1"
				;;
			*.tar.gz) 
				tar xzf "$1"
				;;
			*.tgz) 
				tar xzf "$1"
				;;
			*.gz) 
				gunzip "$1"
				;;
			*.tar.bz2) 
				tar xjf "$1"
				;;
			*.tbz2)
				tar xjf "$1"
				;;
			*.bz2) 
				bunzip2 "$1"
				;;
			*.rar) 
				unrar x "$1"
				;;
			*.zip) 
				unzip "$1"
				;;
			*.Z) 
				uncompress "$1"
				;;
			*.7z) 
				7z x "$1"
				;;
			*)
				echo "Unrecognized format '$1', likely tool isn't installed to decompress"
				;;
		esac
	else
		echo "'$1' is not a valid file"
		echo "extract <file>"
	fi
}

# todo tracker
# usage: todo <add|list|done> [item|line_number]
todo() {
	case ${1:help} in
		add)
			shift
			[[ $# -gt 0 ]] || { echo "Usage: todo add \"<text>\"" ; return 2 ; }
			echo "- $*" >> ~/.todo
			echo "Added: $*"
			;;
		list)
			cat ~/.todo
			;;
		edit)
			"${EDITOR:-vim}" ~/.todo
			;;
		done)
			shift
			[[ ${1:-} =~ ^[1-9][0-9]*$ ]] || {
				echo "Usage: todo done <line_number>"
				return 2
			}
			sed -i "${1}d" ~/.todo
			echo "Removed item $1"
			;;
		*)
			cat <<'EOF'
Usage:
  todo add <text>		Add an item
  todo list			Show all items
  todo edit			Edit todo file with "${EDITOR}"
  todo done <line_number>	Remove an item by line number
EOF
			;;
	esac
}

# base64 encoder/decoder
# usage: b64 <enc(ode)|dec(ode)> <text|file>
b64() {
	case "$1" in
		enc|encode)
			shift
			if [ -f "$1" ] ; then
				base64 -w0 $1
			else
				echo "$1" | base64 -w0
			fi
			;;
		dec|decode)
			shift
			if [ -f "$1" ] ; then
				base64 -d $1
			else
				echo "$1" | base64 -d
			fi
			;;
		*)
			echo "Usage: b64 <enc(ode)|dec(ode)> <\"text\"|file>"
			;;
	esac
}

# quick archive
# usage: rk <file|folder>
rk() {
	if [ ! -d "~/.rk" ] ; then
		mkdir ~/.rk
	else
		:
	fi

	rsync --human-readable --progress --modify-window=1 --partial --compress --archive "$1" ~/.rk/${1%/}-backup.$(date +%Y%m%d_%H%M)
}
######### functions ########
