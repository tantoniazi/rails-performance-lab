# Slow Queries

Heavy aggregations (e.g. counting related records for many parents) are optimized by:

1. **Single aggregation query** with `GROUP BY` instead of N+1 counts.
2. **Counter cache** column on the parent (e.g. `posts.comments_count`) for O(1) read.

Run: `./scripts/run_benchmarks.sh slow_queries`
