# frozen_string_literal: true

# BAD: Counting associated records on every request (N+1 or extra query).
# Even with includes, you load all posts into memory just to count.

User.limit(500).each { |u| u.posts.count }
