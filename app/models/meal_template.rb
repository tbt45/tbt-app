class MealTemplate < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :calories, presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than: 100_000 }

  scope :alphabetical, -> { order(:name) }
end
