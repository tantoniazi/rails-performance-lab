# frozen_string_literal: true

# BAD: OFFSET pagination. Page 10000 requires scanning and skipping 10000 * 20 rows.
# Gets slower as page number increases.

Post.order(:id).offset(199_980).limit(20)
