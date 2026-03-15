# frozen_string_literal: true

# BAD: Repeated subqueries or multiple round-trips for the same "active users" set.
# Simulated: two separate queries that both filter active users.

active_user_ids = User.where(active: true).pluck(:id)
Post.where(user_id: active_user_ids).where(published_at: nil).count
Order.where(user_id: active_user_ids).where(status: "pending").count
