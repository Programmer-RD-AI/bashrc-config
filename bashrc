#!/bin/bash

# Modular Initialization
[[ $- != *i* ]] && return  # Exit if not interactive

# ────────────────────────────── PATH ──────────────────────────────── 
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/anaconda3/bin:$PATH"
export PATH="$HOME/.nvm/versions/node/current/bin:$PATH"

# ────────────────────────── Environment ────────────────────────────
export EDITOR='nvim'
export VISUAL='code'
export TERMINAL='kitty'
export BROWSER='google-chrome'
export LANG='en_US.UTF-8'
export TERM='xterm-256color'

# ───────────────────────── Shell Options ───────────────────────────
shopt -s autocd             # Type directory to cd
shopt -s cdspell            # Autocorrect cd typos
shopt -s dirspell           # Spelling correction for directories
shopt -s checkwinsize       # Update window size after commands
shopt -s globstar           # Recursive globbing
shopt -s histappend         # Append to history
set -o vi                   # Vi mode in bash

# ────────────────────────── Color Setup ────────────────────────────
if [[ -f /usr/bin/dircolors ]]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# ────────────────────────── Prompt Setup ────────────────────────────
__git_status() {
    local status=$(git status 2>/dev/null)
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    
    if [[ -n "$branch" ]]; then
        if [[ "$status" == *"nothing to commit"* ]]; then
            echo " $branch ✓"
        elif [[ "$status" == *"Changes not staged"* ]]; then
            echo " $branch ✗"
        else
            echo " $branch ⚠️"
        fi
    fi
}

__prompt_command() {
    local EXIT="$?"
    local RCol='\[\e[0m\]'
    local Red='\[\e[0;31m\]'
    local Gre='\[\e[0;32m\]'
    local BYel='\[\e[1;33m\]'
    local BBlu='\[\e[1;34m\]'
    local Pur='\[\e[0;35m\]'

    PS1="${Gre}┌─[${BYel}\u${RCol}@${BBlu}\h${Gre}]─[${Pur}\w${RCol}$(__git_status)${Gre}]\n"
    PS1+="${Gre}└─${Red}❯${RCol} "
}
PROMPT_COMMAND=__prompt_command

# ────────────────────────── History Config ────────────────────────
HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# ────────────────────────── Aliases ────────────────────────────────
# Safety & Enhanced Defaults
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -i'
alias mkdir='mkdir -pv'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Listing
alias ls='exa --color=always --icons'
alias ll='exa -lhgF --git --color=always'
alias la='exa -lahgF --git --color=always'
alias tree='exa --tree --level=2 --color=always'

# Search & Find
alias grep='grep --color=auto'
alias rg='rg --color=always'
alias fd='fd --color=always'

# System
alias df='df -h'
alias free='free -h'
alias top='htop'

# ────────────────────────── Completions ────────────────────────────
[[ -f /usr/share/bash-completion/bash_completion ]] && source /usr/share/bash-completion/bash_completion
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

# ────────────────────────── Tool Initializations ────────────────────
# Conda
__conda_setup="$('/home/ranuga/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    [[ -f "/home/ranuga/anaconda3/etc/profile.d/conda.sh" ]] && source "/home/ranuga/anaconda3/etc/profile.d/conda.sh"
fi
unset __conda_setup

# NVM
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# ────────────────────────── Local Overrides ────────────────────────
[[ -f ~/.bash_local ]] && source ~/.bash_local
[[ -f ~/.bash_private ]] && source ~/.bash_private
