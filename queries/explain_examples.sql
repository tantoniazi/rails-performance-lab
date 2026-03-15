-- EXPLAIN and EXPLAIN ANALYZE examples for the Rails Performance Lab
-- Run via: psql -f queries/explain_examples.sql
-- Or: ./scripts/explain_query.sh "SELECT * FROM users WHERE email = 'user1@example.com'"

-- =============================================================================
-- 1. EXPLAIN (no execution) - shows estimated plan
-- =============================================================================
EXPLAIN
SELECT * FROM users WHERE email = 'user1@example.com';

-- =============================================================================
-- 2. EXPLAIN ANALYZE (executes query) - shows actual rows and time
-- =============================================================================
EXPLAIN (ANALYZE, COSTS, FORMAT TEXT)
SELECT * FROM users WHERE email = 'user1@example.com';

-- =============================================================================
-- 3. EXPLAIN with BUFFERS - shows shared hit/read (cache vs disk)
-- =============================================================================
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT * FROM users WHERE id = 1;

-- =============================================================================
-- 4. Sequential scan (slow) - no index on filter column
--    Drop index for demo: DROP INDEX IF EXISTS idx_users_email;
-- =============================================================================
-- EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'user99999@example.com';

-- =============================================================================
-- 5. Index Scan (fast) - with idx_users_email
-- =============================================================================
EXPLAIN (ANALYZE, FORMAT TEXT)
SELECT * FROM users WHERE email = 'user1@example.com';

-- =============================================================================
-- 6. Index Only Scan (covering index) - when index contains all needed columns
-- =============================================================================
EXPLAIN (ANALYZE, FORMAT TEXT)
SELECT id, email FROM users WHERE active = true LIMIT 100;

-- =============================================================================
-- 7. Nested Loop / Hash Join - multi-table query
-- =============================================================================
EXPLAIN (ANALYZE, FORMAT TEXT)
SELECT u.id, u.email, COUNT(p.id)
FROM users u
LEFT JOIN posts p ON p.user_id = u.id
WHERE u.active = true
GROUP BY u.id, u.email
LIMIT 100;

-- =============================================================================
-- How to read the output:
-- - Seq Scan on users: full table scan (bad for large tables)
-- - Index Scan using idx_users_email: uses index (good)
-- - actual time=0.042..0.043: time in ms (start..end)
-- - rows=1: actual rows returned
-- - Buffers: shared hit=4 = 4 pages from cache; read=0 = no disk read
-- - Planning Time / Execution Time: total cost
-- =============================================================================
