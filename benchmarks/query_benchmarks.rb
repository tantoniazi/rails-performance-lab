# frozen_string_literal: true

# Master benchmark script: runs all example benchmarks and prints summary.
# Run: ruby -r ./config/environment benchmarks/query_benchmarks.rb

require "benchmark/ips"

EXAMPLES = %w[
  n_plus_one
  missing_indexes
  slow_queries
  bad_joins
  pagination_problems
  counter_cache
  select_vs_select_all
  pluck_vs_map
  cte_optimization
  materialized_views
].freeze

EXAMPLES.each do |name|
  path = File.expand_path("../examples/#{name}/benchmark.rb", __dir__)
  next unless File.file?(path)

  puts "\n" + "=" * 60
  puts " #{name}"
  puts "=" * 60
  load path
end

puts "\nDone. Run individual: ./scripts/run_benchmarks.sh <name>"
