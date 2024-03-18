#!/usr/bin/env sh

problemId=$1

fd --color=never --type=file --extension=cpp --exact-depth=3 |
	fzf --tiebreak=begin --query "$problemId" \
		--preview "bat -pP -l cpp --color=always {}" \
		--preview-window 'up,80%,border-bottom,~3,follow'
