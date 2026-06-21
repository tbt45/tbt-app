class ExerciseTemplate < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :calories_burned, presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than: 100_000 }
  validates :duration_minutes,
            numericality: { only_integer: true, greater_than: 0, less_than: 1440 },
            allow_nil: true

  scope :alphabetical, -> { order(:name) }
end
