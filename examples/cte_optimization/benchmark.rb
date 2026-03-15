# frozen_string_literal: true

require "benchmark/ips"

Benchmark.ips do |x|
  x.config(time: 3, warmup: 1)

  x.report("two queries (active users twice)") do
    ids = User.where(active: true).pluck(:id)
    Post.where(user_id: ids).where(published_at: nil).count
    Order.where(user_id: ids).where(status: "pending").count
  end

  x.report("CTE-style from subquery") do
    subq = User.where(active: true).select(:id)
    Post.from("(#{subq.to_sql}) AS au").where("posts.user_id = au.id").where(published_at: nil).count
    Order.from("(#{subq.to_sql}) AS au").where("orders.user_id = au.id").where(status: "pending").count
  end

  x.compare!
end
