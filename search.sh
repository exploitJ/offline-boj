#!/usr/bin/env sh

scriptDir=$(dirname "$(realpath "$0")")
rootDir=$(dirname "$scriptDir")

PREVIEWER="$scriptDir/preview.sh"
SEARCH_PREFIX="$scriptDir/_boj_search.sh"
INITIAL_QUERY="$1"

if ! nc -zw1 www.acmicpc.net 443 >/dev/null 2>&1; then
    FZF_DEFAULT_COMMAND="fd --type directory --max-depth=2 --min-depth=2 --color=never --full-path '${rootDir}/cache/' --exec=basename" \
        fzf --query "$INITIAL_QUERY" \
        --preview-window 'right,70%,wrap,<80(up,70%)' \
        --preview "$PREVIEWER {1}"
else
    FZF_DEFAULT_COMMAND="$SEARCH_PREFIX '$INITIAL_QUERY'" \
        fzf --bind "change:reload:$SEARCH_PREFIX {q}" \
        --disabled --query "$INITIAL_QUERY" \
        --preview-window 'right,70%,wrap,<80(up,70%)' \
        -d '\t' \
        --preview "$PREVIEWER {2}"
fi
