# frozen_string_literal: true

# Optional: generate a smaller dataset for quick benchmarks.
# Run: ruby -r ./config/environment scripts/generate_test_data.rb
# Adjust constants below for smaller/larger data.

require_relative "../config/environment"

BATCH = 5000

puts "Generating smaller test dataset..."

User.import(
  %w[email name active created_at updated_at metadata],
  (1..BATCH).map { |i| ["user#{i}@example.com", "User #{i}", true, Time.current, Time.current, {}] },
  batch_size: 1000
)

user_ids = User.pluck(:id)
post_rows = user_ids.flat_map { |uid| (1..20).map { [uid, "Post #{uid}", "Body", Time.current, 0, Time.current, Time.current] } }
Post.import(
  %w[user_id title body published_at comments_count created_at updated_at],
  post_rows.first(100_000),
  batch_size: 5000
)

post_ids = Post.pluck(:id)
comment_rows = post_ids.first(20_000).flat_map { |pid| (1..3).map { [pid, user_ids.sample, "Comment", false, Time.current, Time.current] } }
Comment.import(
  %w[post_id user_id body approved created_at updated_at],
  comment_rows,
  batch_size: 5000
)

Order.import(
  %w[user_id total_cents status created_at updated_at],
  user_ids.first(10_000).map { [_1, 10000, "pending", Time.current, Time.current] },
  batch_size: 2000
)

puts "Done. Users: #{User.count}, Posts: #{Post.count}, Comments: #{Comment.count}, Orders: #{Order.count}"
