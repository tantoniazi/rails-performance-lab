# Bad Joins

## Problem

Joining multiple large tables (users → posts → comments) with `SELECT *` and no early filtering leads to large intermediate result sets and slow execution.

## Solutions

1. **Select only needed columns** to reduce data transfer and memory.
2. **Use EXISTS** instead of JOIN when you only need to filter (e.g. "users who have approved comments").
3. **Ensure indexes** on foreign keys and filter columns (post_id, user_id, approved).
4. **Partial indexes** e.g. on `comments(approved)` where `approved = true`.

Run: `./scripts/run_benchmarks.sh bad_joins`
