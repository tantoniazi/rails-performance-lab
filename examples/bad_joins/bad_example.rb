# frozen_string_literal: true

# BAD: Joining multiple large tables without proper indexes or with SELECT *.
# This can cause huge intermediate result sets and slow hash/merge joins.

User.joins(posts: :comments)
    .where(comments: { approved: true })
    .select("users.*")
    .distinct
    .limit(1000)

# Problem: large join, no covering index, possible sort for distinct.
