# frozen_string_literal: true

# GOOD: Use counter_cache (posts.comments_count) or a single aggregation query.
# One query to get counts for many posts:

post_ids = Post.limit(500).pluck(:id)
Comment.where(post_id: post_ids).group(:post_id).count

# Or if counter_cache is maintained: just read the column.
Post.where(id: post_ids).pluck(:id, :comments_count).to_h
