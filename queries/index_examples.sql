-- Index examples for the Rails Performance Lab
-- Run in psql or via Rails: ActiveRecord::Base.connection.execute(File.read("queries/index_examples.sql"))

-- =============================================================================
-- B-tree (default) - equality and range on scalars
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);
CREATE INDEX IF NOT EXISTS idx_posts_user_id ON posts(user_id);

-- =============================================================================
-- Composite index - for (user_id, created_at) order and filter
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_posts_user_created ON posts(user_id, created_at);

-- =============================================================================
-- Partial index - only index rows matching condition (smaller, faster)
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_users_active_email ON users(email) WHERE active = true;

-- =============================================================================
-- Covering index (INCLUDE) - index holds extra columns to avoid heap fetch
-- PostgreSQL 11+
-- =============================================================================
-- CREATE INDEX idx_users_email_covering ON users(email) INCLUDE (name);

-- =============================================================================
-- GIN index - for JSONB and full-text
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_users_metadata_gin ON users USING gin(metadata);

-- =============================================================================
-- GIN vs BTREE for JSONB
-- BTREE: good for @> containment on top-level keys (e.g. metadata->'role' = 'admin')
-- GIN: good for arbitrary key/value and containment queries
-- =============================================================================

-- =============================================================================
-- Drop index (for before/after benchmark)
-- =============================================================================
-- DROP INDEX IF EXISTS idx_users_email;
