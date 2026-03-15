# Counter Cache

Store the count of an association on the parent row to avoid repeated COUNT queries.

1. Add column: `add_column :users, :posts_count, :integer, default: 0`
2. In child: `belongs_to :user, counter_cache: true`
3. Backfill: `User.find_each { |u| User.reset_counters(u.id, :posts) }`

Then use `user.posts_count` (one column read) instead of `user.posts.count` (extra query).

Run: `./scripts/run_benchmarks.sh counter_cache`
