#!/usr/bin/env sh

utilsDir="$(dirname "$(realpath "$0")")"
rootDir=$(dirname "$utilsDir")
working="$rootDir/answer.cpp"
workingDir="$rootDir/current"
[ -L "$working" ] && [ -f "$working" ] || exit 1
[ -L "$workingDir" ] && [ -d "$workingDir" ] || exit 1

clang++ -o "$workingDir/build.out" "$working"

validate() {
	[ -f "$workingDir/input$1.txt" ] && [ -f "$workingDir/output$1.txt" ] || return 1

	output="$("$workingDir/build.out" <"$workingDir/input$1.txt")"

	if difference=$(printf '%s\n' "$output" | diff -u "$workingDir/output$1.txt" -); then
		status="PASSED"
		printf '\e[32m#%s %s\e[0m\n' "$1" "$status"
	else
		status="FAILED"
		printf '\e[31m#%s %s\e[0m%s\n\n' "$1" "$status" \
			"$(printf '%s' "$difference" | delta -s --paging never \
				--no-gitconfig --file-style omit --hunk-header-style omit)"
	fi

	return 0
}

i=1
while validate "$i"; do
	i=$((i + 1))
done
