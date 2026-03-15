# frozen_string_literal: true

require "benchmark/ips"

Benchmark.ips do |x|
  x.config(time: 3, warmup: 1)

  x.report("N+1 comments count") do
    Post.limit(100).map { |p| p.comments.count }
  end

  x.report("group count (good)") do
    ids = Post.limit(100).pluck(:id)
    Comment.where(post_id: ids).group(:post_id).count
  end

  x.report("counter_cache (good)") do
    Post.limit(100).pluck(:id, :comments_count).to_h
  end

  x.compare!
end
