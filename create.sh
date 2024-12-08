#!/usr/bin/env sh

scriptDir=$(dirname "$(realpath "$0")")
rootDir=$(dirname "$scriptDir")

SEARCHER="$scriptDir/search.sh"
FETCHER="$scriptDir/_fetcher.sh"
LINKER="$scriptDir/use.sh"
EXCLUDE_PATTERN='#problem-info tr > :nth-child(n+3),#hint,#sampleinput2,#sampleoutput2,#sampleinput3,#sampleoutput3,#sampleinput4,#sampleoutput4,#sampleinput5,#sampleoutput5,#sampleinput6,#sampleoutput6,#sampleinput7,#sampleoutput7,#sampleinput8,#sampleoutput8,#sampleinput9,#sampleoutput9,#sampleinput10,#sampleoutput10'

if [ -z "$1" ]; then
    problemId=$("$SEARCHER" | cut -f2)
else
    problemId=$1
fi
[ "$problemId" -gt 0 ] 2>/dev/null || exit 1

srcDir="$rootDir/source/$problemId"
cacheDir="$rootDir/cache/$problemId"
[ -d "$srcDir" ] || mkdir -p "$srcDir"
[ -d "$cacheDir" ] || mkdir -p "$cacheDir"

rawContent=$("$FETCHER" "$problemId" "$cacheDir") || exit 1

sampleDataCount="$(printf '%s' "$rawContent" |
    hxselect -i '.sampledata' |
    hxcount | tail -n1 |
    awk '{print $1/2}')"

i=1
while [ $i -le "$sampleDataCount" ]; do
    printf '%s\n' "$(printf '%s' "$rawContent" | hxselect -i -c "#sample-input-$i" | tr -d '\r')" >"$srcDir/input$i.txt"
    printf '%s\n' "$(printf '%s' "$rawContent" | hxselect -i -c "#sample-output-$i" | tr -d '\r')" >"$srcDir/output$i.txt"
    i=$((i + 1))
done

link="https://www.acmicpc.net/problem/$problemId"
cache_md="$cacheDir/preview.md"
if [ -r "$cache_md" ]; then
    description=$(pandoc -f gfm -t plain "$cache_md")
else
    description="$(printf '%s' "$rawContent" | hxremove "$EXCLUDE_PATTERN" | pandoc -f html -t plain)"
fi

filename="solution"
i=1
while [ -f "$srcDir/$filename-$i.cpp" ]; do
    i=$((i + 1))
done
filename="$filename-$i"

docs=$(printf '%s\n%s' "$link" "$description" | sed 's@^@ * @' | sed 's/[[:space:]]*$//')
printf '/**\n%s\n*/\n\n' "$docs" |
    cat - "$scriptDir/template.cpp" >"$srcDir/$filename.cpp"

"$LINKER" "$srcDir/$filename.cpp"
