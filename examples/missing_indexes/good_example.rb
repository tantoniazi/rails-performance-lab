# frozen_string_literal: true

# GOOD: Lookup by email WITH index (idx_users_email).
# With index: PostgreSQL uses Index Scan, O(log n) instead of full table scan.
#
# Ensure index exists:
#   CREATE INDEX idx_users_email ON users(email);

User.find_by(email: "user1@example.com")
