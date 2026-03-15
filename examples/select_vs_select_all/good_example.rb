# frozen_string_literal: true

# GOOD: Select only the columns you need. Less data from DB, less memory in Ruby.

User.select(:id, :email).limit(5000).each(&:email)

# Or for just an array of values: pluck (no AR objects at all)
User.limit(5000).pluck(:email)
