# frozen_string_literal: true

# BAD: Lookup by email without an index (or with index dropped for demo).
# Without index: PostgreSQL does a sequential scan on the entire users table.
#
# To simulate "missing index": drop the index in migration or SQL:
#   ActiveRecord::Base.connection.execute("DROP INDEX IF EXISTS idx_users_email;")
# Then run this and compare EXPLAIN.

User.find_by(email: "user1@example.com")
