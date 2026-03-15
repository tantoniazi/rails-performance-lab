# frozen_string_literal: true

# GOOD: Use a counter cache column.
# We have posts.comments_count. For user->posts count we could add users.posts_count.
#
# In schema: add_column :users, :posts_count, :integer, default: 0
# In Post model: belongs_to :user, counter_cache: true
# Then User just reads the column:

# If users had posts_count:
# User.select(:id, :email, :posts_count).limit(500)

# Here we use the existing posts.comments_count (counter cache for comments per post)
Post.select(:id, :title, :comments_count).limit(500)
