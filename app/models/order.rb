# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :payments, dependent: :destroy
  has_many :invoices, dependent: :destroy

  validates :status, presence: true
end
