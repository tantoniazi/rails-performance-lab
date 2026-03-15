# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :order
end
