# frozen_string_literal: true

# BAD: Heavy aggregation on every request (e.g. post counts per user).
# Runs full scan + group by each time.

User.joins(:posts).group("users.id").count("posts.id")
