# frozen_string_literal: true

require "benchmark/ips"

Benchmark.ips do |x|
  x.config(time: 3, warmup: 1)

  x.report("posts.count (N+1)") do
    User.limit(100).each { |u| u.posts.count }
  end

  x.report("counter_cache (comments_count on Post)") do
    Post.limit(100).pluck(:id, :comments_count)
  end

  x.report("single GROUP count") do
    user_ids = User.limit(100).pluck(:id)
    Post.where(user_id: user_ids).group(:user_id).count
  end

  x.compare!
end
