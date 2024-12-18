#!/usr/bin/env sh

scriptDir=$(dirname "$(realpath "$0")")
rootDir=$(dirname "$scriptDir")

[ -L "$rootDir/current" ] && [ -d "$rootDir/current" ] || exit 1
curr=$(realpath "$rootDir/current")
problemId=$(basename "$curr")
[ "$problemId" -ge 0 ] 2>/dev/null || exit 1

answer="$rootDir/answer.cpp"

unameOut="$(uname -s)"
case "${unameOut}" in
Linux*)
    wl-copy <"$answer"
    xdg-open "https://www.acmicpc.net/submit/$problemId"
    ;;
Darwin*)
    pbcopy <"$answer"
    open "https://www.acmicpc.net/submit/$problemId"
    ;;
*)
    exit 3
    ;;
esac
