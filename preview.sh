#!/usr/bin/env bash

scriptDir=$(dirname "$(realpath "$0")")
rootDir=$(dirname "$scriptDir")

if [ -z "$1" ]; then
	[ -L "$rootDir/current" ] && [ -d "$rootDir/current" ] || exit 1
	curr=$(realpath "$rootDir/current")
	problemId=$(basename "$curr")
else
	problemId=$1
fi
[ "$problemId" -ge 0 ] 2>/dev/null || exit 1

if [ -n "$FZF_PREVIEW_COLUMNS" ]; then
	params=("--style" "dark" "-w" "$FZF_PREVIEW_COLUMNS")
fi

cacheDir="$rootDir/cache/$problemId"
[ -d "$cacheDir" ] || mkdir -p "$cacheDir"

cache_md="$cacheDir/preview.md"
if [ -r "$cache_md" ]; then
	glow "${params[@]}" <"$cache_md"
	exit 0
fi

FETCHER="$scriptDir/_fetcher.sh"
EXCLUDE_PATTERN='#problem-info tr > :nth-child(n+3),#hint,#sampleinput2,#sampleoutput2,#sampleinput3,#sampleoutput3,#sampleinput4,#sampleoutput4,#sampleinput5,#sampleoutput5,#sampleinput6,#sampleoutput6,#sampleinput7,#sampleoutput7,#sampleinput8,#sampleoutput8,#sampleinput9,#sampleoutput9,#sampleinput10,#sampleoutput10'

set -o pipefail
if fresh_md=$("$FETCHER" "$problemId" "$cacheDir" |
	hxremove -i "$EXCLUDE_PATTERN" |
	pandoc -f html \
		-t gfm-raw_html \
		--extract-media "$cacheDir/media" \
		--wrap none); then
	printf '%s\n' "$fresh_md" | tee "$cache_md" | glow "${params[@]}"
fi
