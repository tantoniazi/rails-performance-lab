# frozen_string_literal: true

# BAD: SELECT * loads every column. With many rows and wide tables (text, jsonb),
# this uses more memory and I/O than needed.

User.limit(5000).each(&:email)
