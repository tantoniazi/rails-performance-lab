# frozen_string_literal: true

# GOOD: Query a materialized view that pre-computes the aggregation.
# Create with: see db/migrate or queries/materialized_view_examples.sql
# Refresh periodically: ActiveRecord::Base.connection.execute("REFRESH MATERIALIZED VIEW user_post_counts;")

# If the materialized view exists:
# ActiveRecord::Base.connection.execute("SELECT * FROM user_post_counts LIMIT 100")
# Or wrap in a model or use .select_all.

result = ActiveRecord::Base.connection.select_all("SELECT * FROM user_post_counts LIMIT 100")
result.to_a
