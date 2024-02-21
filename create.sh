#!/usr/bin/env sh

rootDir="$(dirname "$(realpath "$0")")"
SEARCHER="$rootDir/search.sh"
PREVIEWER="$rootDir/preview.sh"
EXCLUDE_PATTERN='#sampleinput2,#sampleoutput2,#sampleinput3,#sampleoutput3,#sampleinput4,#sampleoutput4,#sampleinput5,#sampleoutput5,#sampleinput6,#sampleoutput6,#sampleinput7,#sampleoutput7,#sampleinput8,#sampleoutput8,#sampleinput9,#sampleoutput9,#sampleinput10,#sampleoutput10'

if [ -z "$1" ]; then
	problemId=$("$SEARCHER" | cut -f2)
else
	problemId=$1
fi
[ "$problemId" -ge 0 ] 2>/dev/null || exit 1

link="https://www.acmicpc.net/problem/$problemId"
rawContent=$("$PREVIEWER" "$problemId" | sed 's@<img[^\/]*src="\([^"]*\)"[^<]*\>@\1\n@g')
sampleDataCount="$(
	printf "%s" "$rawContent" | hxselect -i '.sampledata' | hxcount | tail -n1 | awk '{print $1/2}'
)"
description="$(printf "%s" "$rawContent" | hxremove "$EXCLUDE_PATTERN" | pandoc -f html -t plain)"

printf "%s" "$rawContent" | hxselect -i -c '#sample-input-1' >".input.txt"
printf "%s" "$rawContent" | hxselect -i -c '#sample-output-1' >".output.txt"

filename="b$problemId"
if [ -e "$filename.cpp" ] || [ -L "$filename.cpp" ]; then
	i=1
	while [ -e "$filename-$i.cpp" ] || [ -L "$filename-$i.cpp" ]; do
		i=$((i + 1))
	done
	filename="$filename-$i"
fi

printf '%s\n\n%s\n\n' "$link" "$description" |
	sed 's#^.#// &#' |
	cat - "$rootDir/template_bj.cpp" >"$filename.cpp"
ln -sf "$filename.cpp" ".current.cpp"
