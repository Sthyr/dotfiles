# Set Variables


# Change ZSH Options
#
#
# Create Alias
alias ls='ls -lAFh'
alias hx='helix'

# Customize Prompt
PROMPT='
%2~ %L %# '

RPROMPT='%T'
# Add Locations to $PATH Variable
#
#
# Write Handy Functions
function mkcd() {
  mkdir -p "$@" && cd "$_";
}


# Use ZSH Plugins
