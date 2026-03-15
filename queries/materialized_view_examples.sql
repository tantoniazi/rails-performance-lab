-- Materialized view examples
-- Stores result of a query physically; refresh to update.

-- =============================================================================
-- Create: user post counts (heavy aggregation as a table)
-- =============================================================================
CREATE MATERIALIZED VIEW IF NOT EXISTS user_post_counts AS
SELECT user_id AS id, COUNT(*) AS posts_count
FROM posts
GROUP BY user_id;

CREATE UNIQUE INDEX IF NOT EXISTS idx_user_post_counts_id ON user_post_counts (id);

-- =============================================================================
-- Refresh (run periodically or on demand)
-- =============================================================================
-- REFRESH MATERIALIZED VIEW user_post_counts;

-- CONCURRENTLY avoids locking reads (requires unique index):
-- REFRESH MATERIALIZED VIEW CONCURRENTLY user_post_counts;

-- =============================================================================
-- Query as a normal table
-- =============================================================================
SELECT * FROM user_post_counts ORDER BY posts_count DESC LIMIT 20;

-- =============================================================================
-- Drop
-- =============================================================================
-- DROP MATERIALIZED VIEW IF EXISTS user_post_counts;
