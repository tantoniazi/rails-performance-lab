# Materialized Views

Pre-compute heavy aggregations (e.g. post counts per user) into a materialized view. Reads are then a simple table scan of the MV; update with `REFRESH MATERIALIZED VIEW`.

1. Create: see `queries/materialized_view_examples.sql` or migration.
2. Refresh: `REFRESH MATERIALIZED VIEW user_post_counts;` (scheduled or on demand).
3. Query: `SELECT * FROM user_post_counts LIMIT 100`.

Run: `./scripts/run_benchmarks.sh materialized_views` (after creating the MV).
