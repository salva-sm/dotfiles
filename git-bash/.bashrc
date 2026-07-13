# --- .bashrc ---
# Prevent double loading
if [ -n "$DOTFILES_LOADED" ]; then return; fi
export DOTFILES_LOADED=1

# Repository directory
REPO_BASH_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# 0. Load local, machine-specific config (paths, project names…) if present.
#    env.local is gitignored — copy env.example to env.local and edit it.
if [ -f "$REPO_BASH_DIR/env.local" ]; then
    source "$REPO_BASH_DIR/env.local"
fi

# 1. Load custom prompt
if [ -f "$REPO_BASH_DIR/git-prompt.sh" ]; then
    source "$REPO_BASH_DIR/git-prompt.sh"
else
    # Default fallback prompt
    export PS1='\u@\h \w\$ '
fi

# 2. Aliases
# Open the generated SFCC workspace (see env.example / install.sh).
# Only defined if the workspace has actually been generated.
SFCC_WORKSPACE="$REPO_BASH_DIR/../vscode/workspaces/sfcc.code-workspace"
if [ -f "$SFCC_WORKSPACE" ]; then
    alias sfcc="code '$SFCC_WORKSPACE'"
fi
