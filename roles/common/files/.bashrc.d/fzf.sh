#!/bin/bash
eval "$(fzf --bash)"

alias fe='fzf --preview="bat --color=always --style=numbers {}"'

# yuck but this allows fzf to exit without opening vim on nothing
fvim() {
	local file
	file=$(fe) || return
	vim "$file"
}

alias fv='fvim'
