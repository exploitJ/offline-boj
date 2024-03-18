#!/usr/bin/env sh

if [ -z "$1" ]; then
	exit 1
elif [ -z "$2" ]; then
	exit 2
fi

id="$1"
cacheDir="$2"

[ -d "$cacheDir" ] || mkdir -p "$cacheDir"

cache_html="$cacheDir/raw_html.html"
if [ -r "$cache_html" ]; then
	cat "$cache_html"
	exit 0
fi

if ! nc -zw1 www.acmicpc.net 443 >/dev/null 2>&1; then
	echo "Error: Internet connection required." >&2
	exit 1
fi

userAgent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.5.2 Safari/605.1.15'
imgSrc='https://onlinejudgeimages.s3-ap-northeast-1.amazonaws.com'
removed_element='head,#source,#fb-root,span.problem-label-multilang,script,.no-print,button.copy-button,*[style*="display:none"],*[style*="display: none"]'

curl --fail -s \
	-A "$userAgent" \
	"https://www.acmicpc.net/problem/$id" |
	hxnormalize -x -s -l 99999 |
	hxremove -i "$removed_element" |
	sed "s@<img\(.*\)src=\"\(/JudgeOnline\)\{0,1\}\([^\"]*\)\"\(.*\)/>@<img src=\"\3\"\1\4/>@g; s|<img src=\"\([^h\"][^\"]*\)\"\(.*\)/>|<img src=\"${imgSrc}\1\"\2/>|g" |
	tee "$cache_html"
