# --- git-prompt.sh ---
# 1. WINDOW TITLE
PS1='\[\033]0;\W - Bash\007\]'

# 2. ICON DEFINITIONS
: ${USE_NERD_FONTS:=true}

if [ "$USE_NERD_FONTS" = "true" ]; then
    ARROW=""
    GIT_ICON="󰘬"
else
    ARROW=">"
    GIT_ICON="ᛂ"
fi

DIR_ICON="📂"
HOST_ICON="💻"
USER_ICON="👤"
PROMPT_SYMBOL="🚀"

# 3. COLOR DEFINITIONS
BG_DATE='\[\033[48;5;239m\033[38;5;255m\]'
BG_USER='\[\033[48;5;121m\033[38;5;16m\]'
BG_PATH='\[\033[48;5;230m\033[38;5;16m\]'
BG_GIT='\[\033[48;5;110m\033[38;5;16m\]'

ARR1='\[\033[38;5;239m\033[48;5;121m\]'
ARR2='\[\033[38;5;121m\033[48;5;230m\]'
ARR3='\[\033[38;5;230m\033[48;5;110m\]'
ARR_END_PATH='\[\033[0m\033[38;5;230m\]'
ARR_END_GIT='\[\033[0m\033[38;5;110m\]'
RESET='\[\033[0m\]'

# 4. PROMPT BUILDING LOGIC
build_ps1() {
    PS1='\n'
    # Date/Time segment
    PS1="$PS1""$BG_DATE"" \t ""$RESET"

    # Identify User/Host (Uses system variables for speed)
    PS1="$PS1""$ARR1""$ARROW""$BG_USER"" $USER_ICON $USER@$HOSTNAME ""$RESET"

    # Path segment
    PS1="$PS1""$ARR2""$ARROW""$BG_PATH"" $DIR_ICON \W ""$RESET"

    # Git Branch detection (Direct file read for performance)
    local GIT_BRANCH=""
    local git_dir=$(git rev-parse --git-dir 2>/dev/null)
    if [ -n "$git_dir" ]; then
        GIT_BRANCH=$(sed -e 's,.*/\(.*\),\1,' < "$git_dir/HEAD" 2>/dev/null)
    fi

    if [ -n "$GIT_BRANCH" ]; then
        PS1="$PS1""$ARR3""$ARROW""$BG_GIT"" $GIT_ICON $GIT_BRANCH ""$RESET""$ARR_END_GIT""$ARROW""$RESET"
    else
        PS1="$PS1""$ARR_END_PATH""$ARROW""$RESET"
    fi

    # Lower prompt line
    PS1="$PS1"'\n└─ '"$PROMPT_SYMBOL"' $ '
}

PROMPT_COMMAND=build_ps1
shopt -s no_empty_cmd_completion