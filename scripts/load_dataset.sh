#!/usr/bin/env bash
# Create DB, run migrations, and load seed data.
# Usage: ./scripts/load_dataset.sh

set -e
cd "$(dirname "$0")/.."

echo "Creating database..."
bin/rails db:create 2>/dev/null || true

echo "Running migrations..."
bin/rails db:migrate

echo "Loading seed data (100k users, 1M posts, 3M comments, 500k orders)..."
bin/rails db:seed

echo "Done. Counts:"
bin/rails runner "puts 'Users: ' + User.count.to_s; puts 'Posts: ' + Post.count.to_s; puts 'Comments: ' + Comment.count.to_s; puts 'Orders: ' + Order.count.to_s"
