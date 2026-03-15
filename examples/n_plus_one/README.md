# N+1 Queries

## Problem

Loading 1000 users and then calling `user.posts.count` for each triggers **1001 queries**: one for users, then one per user for the count.

## Solutions

| Method | Queries | Use case |
|--------|--------|----------|
| `includes(:posts)` | 2 | Load users + posts, then use `.size` in memory |
| `preload(:posts)` | 2 | Same as includes for has_many |
| `eager_load(:posts)` | 1 (LEFT JOIN) | Single query, larger payload |
| counter_cache | 1 | Store count on parent (e.g. `users.posts_count`) |

## Run benchmark

```bash
./scripts/run_benchmarks.sh n_plus_one
```

Expect: N+1 ~few ips, includes/preload/eager_load orders of magnitude higher.
