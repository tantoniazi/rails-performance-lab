# frozen_string_literal: true

require "benchmark/ips"
require "memory_profiler"

# Compare SELECT * vs SELECT id, name (or id, email) for memory and speed.

Benchmark.ips do |x|
  x.config(time: 3, warmup: 1)

  x.report("select all (5000)") do
    User.limit(5000).each(&:email)
  end

  x.report("select id,email (5000)") do
    User.select(:id, :email).limit(5000).each(&:email)
  end

  x.report("pluck :email (5000)") do
    User.limit(5000).pluck(:email)
  end

  x.compare!
end

puts "\n--- Memory (single run, 2000 records) ---"
report = MemoryProfiler.report do
  User.limit(2000).each(&:email)
end
puts "SELECT *: allocated #{report.total_allocated_memsize} bytes"

report2 = MemoryProfiler.report do
  User.select(:id, :email).limit(2000).each(&:email)
end
puts "SELECT id,email: allocated #{report2.total_allocated_memsize} bytes"
