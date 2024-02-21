#!/usr/bin/env sh

utilsDir="$(dirname "$(realpath "$0")")"
srcDir="$(dirname "$utilsDir")"

clang++ -o "$utilsDir/current.out" "$(realpath "$srcDir/.current.cpp")"
output="$("$utilsDir/current.out" <"$srcDir/.input.txt")"

printf "%s\n" "$output" | diff -u "$srcDir/.output.txt" - | delta -s
