class Price < ApplicationRecord
  belongs_to :stock

  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :recorded_at, presence: true
end
