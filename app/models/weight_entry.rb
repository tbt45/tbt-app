class WeightEntry < ApplicationRecord
  belongs_to :user

  validates :recorded_on, presence: true, uniqueness: { scope: :user_id }
  validates :weight, presence: true, numericality: { greater_than: 0, less_than: 500 }
  validates :body_fat_percentage, numericality: { greater_than: 0, less_than: 100, allow_nil: true }
end
