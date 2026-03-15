# frozen_string_literal: true

# GOOD: pluck runs a single query and returns an array of values. No AR objects.

User.limit(10_000).pluck(:email)
