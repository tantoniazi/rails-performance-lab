# frozen_string_literal: true

# BAD: N+1 query pattern.
# For each of 1000 users we run a separate query to count posts.
# Total queries: 1 (users) + 1000 (posts.count) = 1001 queries.
#
# Run in console: load "examples/n_plus_one/bad_example.rb"

users = User.limit(1000)
users.each do |user|
  user.posts.count  # N+1: one query per user
end
