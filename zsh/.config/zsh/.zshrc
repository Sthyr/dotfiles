# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Directory to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download zinit if it does not exits
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Load completions
autoload -U compinit && compinit

# Keybindings
bindkey -e # Emacs keybindings
bindkey '^p' history-search-backward # Move history only for current command
bindkey '^n' history-search-forward

# History
export HISTFILE="$XDG_STATE_HOME"/zsh/history
HISTSIZE=5000 # Commands save on history
SAVEHIST=$HISTSIZE
HISTDUP=erase # Erase duplicates in history
setopt appendhistory # appends command to historyu
setopt sharehistory # Share history across all shell sessions
setopt hist_ignore_space # If a command starts with a space it is not saved into the history, useful when using confidential info
setopt hist_ignore_all_dups # Ignore all duplicates
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups  

setopt notify
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$ZDOTDIR/.zshrc'

# End of lines added by compinstall

alias hx=helix
alias update="yay && flatpak update"

# Created by `pipx` on 2026-02-11 19:19:29
export PATH="$PATH:/home/sthyr/.local/bin"

. "$HOME/.local/share/../bin/env"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
