# pluck vs map

## Problem

`User.all.map(&:email)` loads every User as an ActiveRecord object, then extracts email. Huge memory and time for large datasets.

## Solution

`User.pluck(:email)` runs one query and returns an array of strings. No model instantiation.

Run: `./scripts/run_benchmarks.sh pluck_vs_map`

Expect: pluck much faster and lower memory than map.
