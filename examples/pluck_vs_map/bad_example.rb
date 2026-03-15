# frozen_string_literal: true

# BAD: Load full ActiveRecord objects into memory, then map to one attribute.
# Creates 10000 User objects when you only need emails.

User.limit(10_000).map(&:email)
