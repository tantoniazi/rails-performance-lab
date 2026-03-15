#!/usr/bin/env bash
# Run benchmark for one or all example categories.
# Usage: ./scripts/run_benchmarks.sh [n_plus_one|missing_indexes|slow_queries|bad_joins|pagination_problems|counter_cache|select_vs_select_all|pluck_vs_map|cte_optimization|materialized_views]
# With no argument: run all.

set -e
cd "$(dirname "$0")/.."

run_one() {
  local name="$1"
  local path="examples/${name}/benchmark.rb"
  if [[ -f "$path" ]]; then
    echo "===== $name ====="
    ruby -r ./config/environment "$path" || true
    echo ""
  else
    echo "No benchmark at $path"
  fi
}

if [[ -n "$1" ]]; then
  run_one "$1"
else
  for dir in examples/*/; do
    name=$(basename "$dir")
    run_one "$name"
  done
fi
