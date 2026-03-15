#!/usr/bin/env bash
# Run EXPLAIN (ANALYZE, BUFFERS) on a query.
# Usage: ./scripts/explain_query.sh "SELECT * FROM users WHERE email = 'user1@example.com'"
# Or: ./scripts/explain_query.sh  (then type query and Ctrl-D)

set -e
cd "$(dirname "$0")/.."

if [[ -n "$1" ]]; then
  QUERY="$1"
else
  QUERY=$(cat)
fi
[[ -z "$QUERY" ]] && echo "Usage: $0 \"SELECT ...\"" && exit 1

EXPLAIN_QUERY="$QUERY" bin/rails runner scripts/explain_runner.rb
