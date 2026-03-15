# frozen_string_literal: true

# Rails Performance Lab - Seed data using batch inserts for performance.
# Targets: 100k users, 1M posts, 3M comments, 500k orders (+ payments, invoices).
# Run: bin/rails db:seed (or use scripts/load_dataset.sh for progress output)

require "faker"

BATCH_SIZE = 10_000

def log(msg)
  puts "[#{Time.current.strftime('%H:%M:%S')}] #{msg}"
end

def seed_users(count = 100_000)
  log "Seeding #{count} users..."
  attrs = %w[email name active created_at updated_at metadata]
  User.import(attrs, (1..count).map do |i|
    [
      "user#{i}@example.com",
      Faker::Name.name,
      i % 10 != 0, # 90% active
      Time.current,
      Time.current,
      {}.to_json
    ]
  end, batch_size: BATCH_SIZE)
  log "Users done."
end

def seed_posts(count = 1_000_000)
  user_ids = User.pluck(:id)
  log "Seeding #{count} posts..."
  attrs = %w[user_id title body published_at comments_count created_at updated_at]
  total = 0
  user_ids.cycle.each_slice(BATCH_SIZE) do |batch|
    break if total >= count
    slice = batch.first([count - total, BATCH_SIZE].min)
    rows = slice.map do |user_id|
      [user_id, Faker::Lorem.sentence(word_count: 4), Faker::Lorem.paragraph(sentence_count: 2),
       rand(5) == 0 ? nil : Faker::Time.backward(days: 365), 0, Time.current, Time.current]
    end
    Post.import(attrs, rows, batch_size: BATCH_SIZE)
    total += rows.size
    log "  posts #{total}/#{count}" if total % 100_000 == 0 || total == count
  end
  log "Posts done."
end

def seed_comments(count = 3_000_000)
  user_ids = User.pluck(:id)
  log "Seeding #{count} comments (batch by post)..."
  attrs = %w[post_id user_id body approved created_at updated_at]
  total = 0
  now = Time.current
  Post.find_each(batch_size: 5000) do |post|
    break if total >= count
    n = [rand(1..5), count - total].min
    rows = n.times.map { [post.id, user_ids.sample, Faker::Lorem.sentence, rand(3) == 0, now, now] }
    Comment.import(attrs, rows, batch_size: BATCH_SIZE)
    total += rows.size
    log "  comments #{total}/#{count}" if total % 300_000 < n || total == count
  end
  log "Comments done. Updating posts.comments_count..."
  ActiveRecord::Base.connection.execute(<<~SQL)
    UPDATE posts SET comments_count = (
      SELECT COUNT(*) FROM comments WHERE comments.post_id = posts.id
    )
  SQL
  log "Comments count updated."
end

def seed_orders(count = 500_000)
  user_ids = User.pluck(:id)
  statuses = %w[pending paid shipped cancelled]
  log "Seeding #{count} orders..."
  attrs = %w[user_id total_cents status created_at updated_at]
  rows = (1..count).each_slice(BATCH_SIZE).flat_map do |slice|
    slice.map do
      [user_ids.sample, (rand(1000..500_00) * 100), statuses.sample, Time.current, Time.current]
    end
  end
  Order.import(attrs, rows, batch_size: BATCH_SIZE)
  log "Orders done."
end

def seed_payments_and_invoices
  log "Seeding payments and invoices (subset of orders)..."
  order_ids = Order.limit(200_000).pluck(:id)
  payment_attrs = %w[order_id amount_cents gateway created_at updated_at]
  invoice_attrs = %w[order_id number amount_cents created_at updated_at]
  payments = []
  invoices = []
  order_ids.each_with_index do |order_id, i|
    o = Order.find(order_id)
    amt = o.total_cents
    payments << [order_id, amt, %w[stripe paypal bank].sample, Time.current, Time.current]
    invoices << [order_id, "INV-#{100_000 + i}", amt, Time.current, Time.current]
  end
  Payment.import(payment_attrs, payments, batch_size: BATCH_SIZE)
  Invoice.import(invoice_attrs, invoices, batch_size: BATCH_SIZE)
  log "Payments and invoices done."
end

log "Starting Rails Performance Lab seed (batch inserts)..."

seed_users
seed_posts
seed_comments
seed_orders
seed_payments_and_invoices

log "Seed complete."
log "Counts: Users=#{User.count}, Posts=#{Post.count}, Comments=#{Comment.count}, Orders=#{Order.count}, Payments=#{Payment.count}, Invoices=#{Invoice.count}"
