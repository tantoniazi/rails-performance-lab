# frozen_string_literal: true

require "benchmark/ips"
require "memory_profiler"

Benchmark.ips do |x|
  x.config(time: 3, warmup: 1)

  x.report("map(&:email) - load AR") do
    User.limit(1000).map(&:email)
  end

  x.report("pluck(:email)") do
    User.limit(1000).pluck(:email)
  end

  x.compare!
end

puts "\n--- Memory (1000 records) ---"
r1 = MemoryProfiler.report { User.limit(1000).map(&:email) }
r2 = MemoryProfiler.report { User.limit(1000).pluck(:email) }
puts "map(&:email): #{r1.total_allocated_memsize} bytes"
puts "pluck(:email): #{r2.total_allocated_memsize} bytes"
