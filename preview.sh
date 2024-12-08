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
    params=("--style" "dark" "-w" "$((FZF_PREVIEW_COLUMNS - 4))")
fi

cacheDir="$rootDir/cache/$problemId"
[ -d "$cacheDir" ] || mkdir -p "$cacheDir"

export CLICOLOR_FORCE=1
export COLORTERM=truecolor

cache_md="$cacheDir/preview.md"
if [ ! -r "$cache_md" ]; then
    FETCHER="$scriptDir/_fetcher.sh"
    EXCLUDE_PATTERN='#problem-info tr > :nth-child(n+3),#hint,#sampleinput2,#sampleoutput2,#sampleinput3,#sampleoutput3,#sampleinput4,#sampleoutput4,#sampleinput5,#sampleoutput5,#sampleinput6,#sampleoutput6,#sampleinput7,#sampleoutput7,#sampleinput8,#sampleoutput8,#sampleinput9,#sampleoutput9,#sampleinput10,#sampleoutput10'

    set -o pipefail
    if fresh_md=$("$FETCHER" "$problemId" "$cacheDir" |
        hxremove -i "$EXCLUDE_PATTERN" |
        pandoc -f html \
            -t gfm-raw_html \
            --request-header Referer:https://www.acmicpc.net/ \
            --extract-media "$cacheDir/media" \
            --wrap none); then
        printf '%s\n' "$fresh_md" >"$cache_md"
    fi
fi

if [ -d "$cacheDir"/media ] && [ -n "$FZF_PREVIEW_LINES" ]; then
    for img in "$cacheDir"/media/*; do
        kitty icat \
            --transfer-mode=stream \
            --unicode-placeholder \
            --stdin=no \
            --place="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@${FZF_PREVIEW_LEFT}x${FZF_PREVIEW_TOP}" \
            "$img"
        printf '\n'
    done
fi
glow "${params[@]}" <"$cache_md"
