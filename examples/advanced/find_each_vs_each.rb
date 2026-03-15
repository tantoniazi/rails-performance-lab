# frozen_string_literal: true

# find_each loads in batches (default 1000); each loads all records into memory.
# Run in console or benchmark.

# BAD: Loads all 100k users into memory
# User.all.each { |u| u.update!(updated_at: Time.current) }

# GOOD: Processes in batches of 1000
User.find_each(batch_size: 1000) { |u| u.touch }
