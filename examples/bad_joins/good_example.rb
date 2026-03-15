# frozen_string_literal: true

# GOOD: Restrict early, use indexes, select only needed columns.
# Option 1: Filter in subquery / CTE to reduce join size.
# Option 2: Use exists instead of join when you only need to check presence.

# Only users who have at least one approved comment (efficient with indexes)
User.joins(posts: :comments)
    .where(comments: { approved: true })
    .select("users.id", "users.email")
    .distinct
    .limit(1000)

# Or with EXISTS (often faster):
# User.where(
#   "EXISTS (SELECT 1 FROM posts p INNER JOIN comments c ON c.post_id = p.id WHERE p.user_id = users.id AND c.approved = true)"
# ).limit(1000)
