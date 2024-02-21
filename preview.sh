#!/usr/bin/env sh

if [ -z "$1" ]; then
	exit 1
fi

userAgent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.5.2 Safari/605.1.15'
imgSrc='https://onlinejudgeimages.s3-ap-northeast-1.amazonaws.com'

curl --fail -s \
	-A "$userAgent" \
	https://www.acmicpc.net/problem/"$1" |
	hxnormalize -x |
	hxselect '#problem-body' |
	hxremove -i 'button.copy-button,*[style*="display:none"],*[style*="display: none"]' |
	sed "s|/JudgeOnline|${imgSrc}|g"
