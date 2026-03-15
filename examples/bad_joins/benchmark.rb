# frozen_string_literal: true

require "benchmark/ips"

Benchmark.ips do |x|
  x.config(time: 3, warmup: 1)

  x.report("join 3 tables select *") do
    User.joins(posts: :comments).where(comments: { approved: true }).select("users.*").distinct.limit(500).load
  end

  x.report("join 3 tables select id,email") do
    User.joins(posts: :comments).where(comments: { approved: true }).select("users.id", "users.email").distinct.limit(500).load
  end

  x.report("EXISTS subquery") do
    User.where(
      "EXISTS (SELECT 1 FROM posts p INNER JOIN comments c ON c.post_id = p.id WHERE p.user_id = users.id AND c.approved = true)"
    ).limit(500).load
  end

  x.compare!
end
