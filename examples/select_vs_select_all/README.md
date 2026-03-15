# SELECT * vs SELECT specific columns

## Problem

`SELECT *` loads every column (including large text/jsonb). More I/O and memory for the same logical result when you only need one or two columns.

## Solution

Use `select(:id, :name)` or `pluck(:email)` so the DB and Ruby only handle the columns you need.

Run: `./scripts/run_benchmarks.sh select_vs_select_all`

You should see higher iterations/sec and lower memory for select/pluck vs select all.
