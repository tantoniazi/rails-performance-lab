# frozen_string_literal: true

# GOOD: Eager loading and counter_cache.
# Option 1: includes(:posts) loads users + posts in 2 queries, then count in Ruby.
# Option 2: counter_cache uses posts_count column (1 query for users with counter_cache).
# Option 3: preload / eager_load (see comments).

# Using includes (2 queries total: users, then posts for those users)
users = User.includes(:posts).limit(1000)
users.each do |user|
  user.posts.size  # uses loaded association, no extra query
end

# Alternative: preload - same as includes for has_many (2 queries)
# User.preload(:posts).limit(1000).each { |u| u.posts.size }

# Alternative: eager_load - single LEFT OUTER JOIN (1 query, larger result set)
# User.eager_load(:posts).limit(1000).each { |u| u.posts.size }

# Best for counts: counter_cache on User (e.g. users.posts_count) - 1 query
# User.select("users.*, (SELECT COUNT(*) FROM posts WHERE posts.user_id = users.id) AS posts_count").limit(1000)
