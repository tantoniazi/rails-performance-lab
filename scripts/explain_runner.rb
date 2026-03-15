# frozen_string_literal: true

# Called by explain_query.sh with query in ENV['EXPLAIN_QUERY']
query = ENV["EXPLAIN_QUERY"]
abort("Set EXPLAIN_QUERY") if query.blank?

result = ActiveRecord::Base.connection.execute("EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) #{query}")
result.each { |row| puts (row.is_a?(Hash) ? row["QUERY PLAN"] : row[0]) }
