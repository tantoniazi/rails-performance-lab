# CTE Optimization

Using a CTE (Common Table Expression) with `WITH ... AS` lets you define a result set once and reference it multiple times in the same query. Avoids repeated subquery execution and can help the planner.

See `queries/cte_examples.sql` for raw SQL. Run: `./scripts/run_benchmarks.sh cte_optimization` (folder name may be cte_optimization or similar).
