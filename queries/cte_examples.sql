-- CTE (Common Table Expression) examples
-- WITH ... AS defines a named result set you can reference multiple times

-- =============================================================================
-- Simple CTE: active users once, reuse for posts and orders
-- =============================================================================
WITH active_users AS (
  SELECT id FROM users WHERE active = true
)
SELECT
  (SELECT COUNT(*) FROM posts p INNER JOIN active_users au ON p.user_id = au.id WHERE p.published_at IS NULL) AS unpublished_posts,
  (SELECT COUNT(*) FROM orders o INNER JOIN active_users au ON o.user_id = au.id WHERE o.status = 'pending') AS pending_orders;

-- =============================================================================
-- CTE for readability: top posters
-- =============================================================================
WITH post_counts AS (
  SELECT user_id, COUNT(*) AS cnt
  FROM posts
  GROUP BY user_id
)
SELECT u.email, pc.cnt
FROM users u
INNER JOIN post_counts pc ON pc.user_id = u.id
ORDER BY pc.cnt DESC
LIMIT 10;

-- =============================================================================
-- CTE vs normal subquery
-- Planner can optimize CTEs (in PostgreSQL 12+ they can be inlined)
-- =============================================================================
-- Same logic as subquery:
SELECT u.email, (SELECT COUNT(*) FROM posts p WHERE p.user_id = u.id) AS posts_count
FROM users u
ORDER BY posts_count DESC
LIMIT 10;
