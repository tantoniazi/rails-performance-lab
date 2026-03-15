# frozen_string_literal: true

# GOOD: Keyset (cursor) pagination. Constant time regardless of page.
# Use the last seen id/created_at from the previous page.

# First page
Post.order(:created_at, :id).limit(20)

# Next page (keyset): use last created_at and id from previous page
last = Post.order(:created_at, :id).limit(20).last
Post.where("(created_at, id) > (?, ?)", last.created_at, last.id).order(:created_at, :id).limit(20)

# With composite index idx_posts_user_created (user_id, created_at), pagination per user is fast:
# Post.where(user_id: user_id).where("(created_at, id) > (?, ?)", cursor_at, cursor_id).order(:created_at, :id).limit(20)
