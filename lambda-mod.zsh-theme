#!/usr/bin/env zsh

local LAMBDA="%(?,%{$fg_bold[green]%}λ,%{$fg_bold[red]%}λ)"
if [[ "$USER" == "root" ]]; then USERCOLOR="red"; else USERCOLOR="yellow"; fi

if [ "$LAMBDA_GIT_CLEAN" = "" ]; then
  LAMBDA_GIT_CLEAN="%F{green}✔%F{black}"
fi

if [ "$LAMBDA_GIT_DIRTY" = "" ]; then
  LAMBDA_GIT_DIRTY="%F{yellow}✘%F{black}"
fi

if [ "$LAMBDA_GIT_ADDED" = "" ]; then
  LAMBDA_GIT_ADDED="%F{green}✚%F{black}"
fi

if [ "$LAMBDA_GIT_MODIFIED" = "" ]; then
  LAMBDA_GIT_MODIFIED="%F{blue}✹%F{black}"
fi

if [ "$LAMBDA_GIT_DELETED" = "" ]; then
  LAMBDA_GIT_DELETED="%F{red}✖%F{black}"
fi

if [ "$LAMBDA_GIT_UNTRACKED" = "" ]; then
  LAMBDA_GIT_UNTRACKED="%F{yellow}✭%F{black}"
fi

if [ "$LAMBDA_GIT_RENAMED" = "" ]; then
  LAMBDA_GIT_RENAMED="➜"
fi

if [ "$LAMBDA_GIT_UNMERGED" = "" ]; then
  LAMBDA_GIT_UNMERGED="═"
fi

function get_git_prompt_info() {
    if [[ "$(pwd)" == *"Volumes"* ]]; then
        echo "NOPE!"
    else
        git_prompt_info
    fi
}

function get_git_prompt_status() {
    if [[ "$(pwd)" == *"Volumes"* ]]; then
        echo ""
    else
        git_prompt_status
    fi
}

# Git sometimes goes into a detached head state. git_prompt_info doesn't
# return anything in this case. So wrap it in another function and check
# for an empty string.
function check_git_prompt_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [[ $(get_git_prompt_info) == "NOPE!" ]]; then
            echo "
%{$fg_bold[cyan]%}→ "
        elif [[ -z $(get_git_prompt_info) ]]; then
            echo "%{$fg[blue]%}detached-head%{$reset_color%}) $(get_git_prompt_status)
%{$fg[yellow]%}→ "
        else
            echo "$(get_git_prompt_info) $(get_git_prompt_status)
%{$fg_bold[cyan]%}→ "
        fi
    else
        echo "%{$fg_bold[cyan]%}→ "
    fi
}

function get_right_prompt() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo -n "$(git_prompt_short_sha)%{$reset_color%}"
    else
        echo -n "%{$reset_color%}"
    fi
}

PROMPT='
${LAMBDA}\
 %{$fg_bold[$USERCOLOR]%}%n\
 %{$fg_no_bold[magenta]%}[%3~]\
 $(check_git_prompt_info)\
%{$reset_color%}'

RPROMPT='$(get_right_prompt)'

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX="%F{reset}@ %F{blue} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{reset}"
ZSH_THEME_GIT_PROMPT_DIRTY=" $LAMBDA_GIT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN=" $LAMBDA_GIT_CLEAN"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_ADDED=" $LAMBDA_GIT_ADDED"
ZSH_THEME_GIT_PROMPT_MODIFIED=" $LAMBDA_GIT_MODIFIED"
ZSH_THEME_GIT_PROMPT_DELETED=" $LAMBDA_GIT_DELETED"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" $LAMBDA_GIT_UNTRACKED"
ZSH_THEME_GIT_PROMPT_RENAMED=" $LAMBDA_GIT_RENAMED"
ZSH_THEME_GIT_PROMPT_UNMERGED=" $LAMBDA_GIT_UNMERGED"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" ⬆"
ZSH_THEME_GIT_PROMPT_BEHIND=" ⬇"
ZSH_THEME_GIT_PROMPT_DIVERGED=" ⬍"


# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg_bold[white]%}[%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$fg_bold[white]%}]"
