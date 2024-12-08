#!/usr/bin/env sh

rootDir="$(dirname "$(realpath "$0")")"
PREVIEWER="$rootDir/preview.sh"
SEARCH_PREFIX="$rootDir/_boj_search.sh"
INITIAL_QUERY="$1"
# if not found in cache trigger reload else fuzzy find from json
FZF_DEFAULT_COMMAND="$SEARCH_PREFIX '$INITIAL_QUERY'" \
    fzf --bind "change:reload:$SEARCH_PREFIX {q}" \
    --disabled --query "$INITIAL_QUERY" \
    --preview-window 'right,70%,wrap,<80(up,70%)' \
    -d '\t' \
    --preview "$PREVIEWER {2}"
