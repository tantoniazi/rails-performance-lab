# frozen_string_literal: true

require "benchmark/ips"

Benchmark.ips do |x|
  x.config(time: 3, warmup: 1)

  x.report("OFFSET 100 (page 5)") do
    Post.order(:id).offset(100).limit(20).load
  end

  x.report("OFFSET 10000 (page 500)") do
    Post.order(:id).offset(10_000).limit(20).load
  end

  x.report("OFFSET 100000 (page 5000)") do
    Post.order(:id).offset(100_000).limit(20).load
  end

  x.report("Keyset (cursor) after id") do
    last_id = Post.order(:id).limit(20).pick(:id)
    Post.where("id > ?", last_id).order(:id).limit(20).load
  end

  x.compare!
end
