#!/bin/sh

# create 3000 votes (1000 for option a, 1000 for option b)
ab -n 500 -c 50 -p posta -T "application/x-www-form-urlencoded" https://dev-vote.kind.local/
ab -n 500 -c 50 -p postb -T "application/x-www-form-urlencoded" https://dev-vote.kind.local/
