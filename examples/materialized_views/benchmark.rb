# frozen_string_literal: true

require "benchmark/ips"

# Ensure materialized view exists (run migration or SQL from queries/materialized_view_examples.sql)
def matview_exists?
  ActiveRecord::Base.connection.select_value(
    "SELECT 1 FROM pg_matviews WHERE matviewname = 'user_post_counts'"
  ).to_i == 1
end

Benchmark.ips do |x|
  x.config(time: 3, warmup: 1)

  x.report("live aggregation (group count)") do
    User.joins(:posts).group("users.id").count("posts.id")
  end

  if matview_exists?
    x.report("materialized view") do
      ActiveRecord::Base.connection.select_all("SELECT * FROM user_post_counts").to_a
    end
  end

  x.compare!
end
