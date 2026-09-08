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

# Defaults for the choices install.sh writes to env.local.
: ${DOTFILES_CUSTOM_PROMPT:=yes}
: ${DOTFILES_EDITOR:=code}

WORKSPACES_DIR="$REPO_BASH_DIR/../vscode/workspaces"

# Project dirs are relative to WORKSPACES_DIR (the workspace template needs
# them that way); absolute paths are used as-is.
project_path() {
    case $1 in
        "") ;;
        /*|[A-Za-z]:[/\\]*) printf '%s' "$1" ;;
        *) printf '%s' "$WORKSPACES_DIR/$1" ;;
    esac
}
SFCC_PROJECT_PATH=$(project_path "$SFCC_PROJECT_DIR")
PLAYWRIGHT_PROJECT_PATH=$(project_path "$PLAYWRIGHT_PROJECT_DIR")
unset -f project_path

# 1. SFCC OAuth credentials
#    Fall back to the project's source/dw.json when env.local (or the parent
#    shell) doesn't set them. Override the file with SFCC_DW_JSON.
if [ -z "$SFCC_OAUTH_CLIENT_ID" ] || [ -z "$SFCC_OAUTH_CLIENT_SECRET" ]; then
    if [ -z "$SFCC_DW_JSON" ] && [ -n "$SFCC_PROJECT_DIR" ] \
       && [ -f "$SFCC_PROJECT_PATH/source/dw.json" ]; then
        export SFCC_DW_JSON="$SFCC_PROJECT_PATH/source/dw.json"
    fi
    if [ -f "$SFCC_DW_JSON" ]; then
        # dw.json is small and flat, so a "key": "value" reader is enough
        # (no jq in Git Bash).
        dw_json_value() {
            sed -n 's/.*"'"$1"'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$SFCC_DW_JSON" | head -n 1
        }
        [ -z "$SFCC_OAUTH_CLIENT_ID" ] && export SFCC_OAUTH_CLIENT_ID="$(dw_json_value client-id)"
        [ -z "$SFCC_OAUTH_CLIENT_SECRET" ] && export SFCC_OAUTH_CLIENT_SECRET="$(dw_json_value client-secret)"
        unset -f dw_json_value
    fi
fi

# 2. Load custom prompt (opt out with DOTFILES_CUSTOM_PROMPT=no; Git Bash then
#    keeps its own default prompt).
if [ "$DOTFILES_CUSTOM_PROMPT" = "yes" ]; then
    if [ -f "$REPO_BASH_DIR/git-prompt.sh" ]; then
        source "$REPO_BASH_DIR/git-prompt.sh"
    else
        # Default fallback prompt
        export PS1='\u@\h \w\$ '
    fi
fi

# 3. Aliases
# Open the SFCC project in the chosen editor (see env.example / install.sh).
if [ "$DOTFILES_EDITOR" = "zed" ]; then
    # Zed doesn't read .code-workspace files: open the folders directly.
    if [ -d "$SFCC_PROJECT_PATH" ]; then
        if [ -d "$PLAYWRIGHT_PROJECT_PATH" ]; then
            alias sfcc="zed '$SFCC_PROJECT_PATH' '$PLAYWRIGHT_PROJECT_PATH'"
        else
            alias sfcc="zed '$SFCC_PROJECT_PATH'"
        fi
    fi
else
    # Only defined if the workspace has actually been generated.
    SFCC_WORKSPACE="$WORKSPACES_DIR/sfcc.code-workspace"
    if [ -f "$SFCC_WORKSPACE" ]; then
        alias sfcc="code '$SFCC_WORKSPACE'"
    fi
fi
