# frozen_string_literal: true

# For complex reporting, raw SQL can be faster and clearer than chaining AR.
# Trade-off: maintainability and DB portability vs control and speed.

# AR (multiple queries or one big join)
User.joins(:posts).group("users.id").count("posts.id")

# Raw SQL (one query, full control)
ActiveRecord::Base.connection.select_all(<<~SQL).to_a
  SELECT user_id AS id, COUNT(*) AS posts_count
  FROM posts
  GROUP BY user_id
SQL
