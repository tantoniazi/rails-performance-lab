# frozen_string_literal: true

# GOOD: Use a CTE (WITH) so "active users" is computed once and reused.
# In raw SQL (see queries/cte_examples.sql). In Rails we can use .from with a subquery.

active_users_sql = User.where(active: true).select(:id).to_sql
posts_count = Post.from("(#{active_users_sql}) AS active_users")
                 .where("posts.user_id = active_users.id")
                 .where(published_at: nil)
                 .count
orders_count = Order.from("(#{active_users_sql}) AS active_users")
                    .where("orders.user_id = active_users.id")
                    .where(status: "pending")
                    .count

# Or a single query with CTE (run in SQL):
# WITH active_users AS (SELECT id FROM users WHERE active = true)
# SELECT (SELECT COUNT(*) FROM posts p JOIN active_users au ON p.user_id = au.id WHERE p.published_at IS NULL),
#        (SELECT COUNT(*) FROM orders o JOIN active_users au ON o.user_id = au.id WHERE o.status = 'pending');
