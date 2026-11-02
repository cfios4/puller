#!/bin/bash

# Replace ls with eza (pipe-safe)
alias ls='eza --group-directories-first --icons=auto --color=auto'

# All files including hidden
alias ll='ls -la --group --git --header --octal-permissions'

# All files including SELinux
alias lz='ll -@'

# Tree view (limit depth)
alias lt='ls --tree --level=4' tree='lt'
