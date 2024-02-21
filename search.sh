#!/usr/bin/env sh

rootDir="$(dirname "$(realpath "$0")")"
PREVIEWER="$rootDir/preview.sh"
SEARCH_PREFIX="$rootDir/problemSearch.sh"
INITIAL_QUERY="$1"
FZF_DEFAULT_COMMAND="$SEARCH_PREFIX '$INITIAL_QUERY'" \
	fzf --bind "change:reload:$SEARCH_PREFIX {q}" \
	--disabled --query "$INITIAL_QUERY" \
	--preview-window=right,70%,wrap \
	-d '\t' \
	--preview "$PREVIEWER {2} | pandoc -f html -t plain --wrap none"
