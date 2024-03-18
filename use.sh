#!/usr/bin/env sh

scriptDir=$(dirname "$(realpath "$0")")
rootDir=$(dirname "$scriptDir")
SEARCHER="$scriptDir/_src_search.sh"

if [ -z "$1" ]; then
	source=$("$SEARCHER")
else
	source=$1
fi
[ -f "$source" ] 2>/dev/null || exit 1
source=$(realpath "$source")

target="$rootDir/current"
[ -L "$target" ] && [ -d "$target" ] && rm -f "$target"
ln -s "$(dirname "$source")" "$target"
ln -sf "$source" "$rootDir/answer.cpp"
