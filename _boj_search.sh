#!/usr/bin/env sh
category="Problems"
input=$1

userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.5.2 Safari/605.1.15"

curl_to_bj() {
	curl 'https://aewewtnd4p-dsn.algolia.net/1/indexes/*/queries?x-algolia-agent=Algolia%20for%20JavaScript%20(3.33.0)%3B%20Browser%20(lite)%3B%20JS%20Helper%20(2.28.0)&x-algolia-application-id=AEWEWTND4P&x-algolia-api-key=40fa3b88d4994a18f89e692619c9f3f3' \
		-X 'POST' \
		-A "$userAgent" \
		-H 'Content-Type: application/x-www-form-urlencoded' \
		-H 'Accept: application/json' \
		-H 'Host: aewewtnd4p-dsn.algolia.net' \
		-H 'Origin: https://www.acmicpc.net' \
		-H 'Referer: https://www.acmicpc.net/' \
		-H 'Sec-Fetch-Dest: empty' \
		-s \
		--data "$1"
}

request_body() {
	category="Problems"
	query="query=$input&page=$1&facets=%5B%5D&tagFilters="
	jq -n \
		--arg category "$category" \
		--arg params "$query" \
		'{requests:[{indexName:$category,params:$params}]}'
}

first_data=$(curl_to_bj "$(request_body 0)" | tr -d '[:cntrl:]')

i=1
jq -n "$first_data" | jq -r '.results[].hits[] | "\(.title)\t\(.id)"' | hxunent
[ "$input" -ge 0 ] 2>/dev/null && exit 0

number_of_pages=$(jq -n "$first_data" | jq -r '.results[0].nbPages')

while [ "$i" -lt "$number_of_pages" ]; do
	curl_to_bj "$(request_body "$i")" | tr -d '[:cntrl:]' |
		jq -r '.results[].hits[] | "\(.title)\t\(.id)"' | hxunent &

	i=$((i + 1))
done
