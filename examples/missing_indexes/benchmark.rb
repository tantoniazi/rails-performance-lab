# frozen_string_literal: true

# Benchmark: find_by(email) with vs without index.
# Run with index: normal. To benchmark "after index", ensure idx_users_email exists.
# To see "before": drop index, run benchmark, add index, run again.
#
# Run: ruby -r ./config/environment examples/missing_indexes/benchmark.rb

require "benchmark/ips"

email = User.limit(1).pick(:email) || "user1@example.com"

Benchmark.ips do |x|
  x.config(time: 3, warmup: 1)

  x.report("find_by(email) with index") do
    User.find_by(email: email)
  end

  x.compare!
end

# Optional: run EXPLAIN to show index usage
# puts User.where(email: email).explain
