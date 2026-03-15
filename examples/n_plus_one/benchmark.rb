# frozen_string_literal: true

# Benchmark: N+1 vs includes vs counter_cache-style count.
# Run: ruby -r ./config/environment examples/n_plus_one/benchmark.rb
# Or: ./scripts/run_benchmarks.sh n_plus_one

require "benchmark/ips"

Benchmark.ips do |x|
  x.config(time: 3, warmup: 1)

  x.report("N+1 (bad)") do
    users = User.limit(100)
    users.each { |u| u.posts.count }
  end

  x.report("includes (good)") do
    users = User.includes(:posts).limit(100)
    users.each { |u| u.posts.size }
  end

  x.report("preload (good)") do
    users = User.preload(:posts).limit(100)
    users.each { |u| u.posts.size }
  end

  x.report("eager_load (good)") do
    users = User.eager_load(:posts).limit(100)
    users.each { |u| u.posts.size }
  end

  x.report("counter_cache (SQL)") do
    User.left_joins(:posts).group(:id).limit(100).count("posts.id")
  end

  x.compare!
end
