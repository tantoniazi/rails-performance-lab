# Pagination Problems

## Problem

`LIMIT 20 OFFSET 100000` forces PostgreSQL to **compute and skip** 100k rows, then return 20. Cost grows linearly with page number.

## Solution: Keyset (cursor) pagination

- **First page:** `ORDER BY id LIMIT 20`
- **Next page:** `WHERE id > :last_seen_id ORDER BY id LIMIT 20`

Always uses the index; time is constant regardless of "page".

For composite order (e.g. `created_at, id`):  
`WHERE (created_at, id) > (:cursor_at, :cursor_id) ORDER BY created_at, id LIMIT 20`  
with index on `(created_at, id)` or `(user_id, created_at)`.

Run: `./scripts/run_benchmarks.sh pagination_problems`
