# frozen_string_literal: true

# BAD: Heavy aggregation without indexes or with inefficient joins.
# Example: count comments per post for many posts in a single query that
# does multiple full scans or nested loops.

Post.limit(500).map { |p| p.comments.count }
