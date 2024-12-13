#!/bin/bash

# Modular Initialization
[[ $- != *i* ]] && return  # Exit if not interactive

# ────────────────────────────── PATH ──────────────────────────────── 
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/anaconda3/bin:$PATH"
export PATH="$HOME/.nvm/versions/node/current/bin:$PATH"

# ────────────────────────── Color palette ────────────────────────────

export PROMPT_DECO_COLOR='\[\e[38;5;240m\]'  # Muted gray for decorative elements
export USER_COLOR='\[\e[38;5;109m\]'         # Soft teal for username
export HOST_COLOR='\[\e[38;5;174m\]'         # Muted rose for hostname
export PATH_COLOR='\[\e[38;5;143m\]'         # Soft olive green for path
export RESET_COLOR='\[\e[0m\]'               # Reset to default

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
    local status=$(git status -s 2>/dev/null)
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    
    if [[ -n "$branch" ]]; then
        local status_indicators=""
        
        # Check for uncommitted changes
        if [[ -n "$status" ]]; then
            # Count different types of changes
            local untracked=$(echo "$status" | grep -c "??")
            local modified=$(echo "$status" | grep -c "M")
            local staged=$(echo "$status" | grep -c "A")
            local deleted=$(echo "$status" | grep -c "D")
            
            # Build status indicators
            [[ $untracked -gt 0 ]] && status_indicators+="?"
            [[ $modified -gt 0 ]] && status_indicators+="*"
            [[ $staged -gt 0 ]] && status_indicators+="+"
            [[ $deleted -gt 0 ]] && status_indicators+="-"
        fi
        
        # Display branch with status indicators
        if [[ -z "$status_indicators" ]]; then
            echo " ${PROMPT_DECO_COLOR}(${branch})${RESET_COLOR}"
        else
            echo " ${PROMPT_DECO_COLOR}(${branch}${status_indicators})${RESET_COLOR}"
        fi
    fi
}

__prompt_command() {
    local EXIT="$?"
    local LIGHTNING='\342\232\241'  # Unicode lightning bolt for a touch of flair

    # Two-line prompt with minimal decoration
    PS1="${PROMPT_DECO_COLOR}╭${RESET_COLOR} "
    PS1+="${USER_COLOR}\u${PROMPT_DECO_COLOR}@${HOST_COLOR}\h"
    PS1+=" ${PROMPT_DECO_COLOR}▸${PATH_COLOR} \w"
    PS1+="${PROMPT_DECO_COLOR}$(__git_status)${RESET_COLOR}\n"
    
    # Right-side prompt element with dynamic error indication
    if [[ $EXIT != 0 ]]; then
        PS1+="${PROMPT_DECO_COLOR}╰${RESET_COLOR} ${PROMPT_DECO_COLOR}${LIGHTNING}${RESET_COLOR} "
    else
        PS1+="${PROMPT_DECO_COLOR}╰${RESET_COLOR} ${PROMPT_DECO_COLOR}>${RESET_COLOR} "
    fi
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
alias ls='exa --color=always'
alias ll='exa -lhgF --git --color=always'
alias la='exa -lahgF --git --color=always'
alias tree='exa --tree --level=2 --color=always'
alias treeb='exa --tree --level=1 --color=always'

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
