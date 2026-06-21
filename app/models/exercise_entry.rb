class ExerciseEntry < ApplicationRecord
  belongs_to :user

  validates :recorded_on, presence: true
  validates :name, presence: true
  validates :calories_burned, presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than: 100_000 }
  validates :duration_minutes,
            numericality: { only_integer: true, greater_than: 0, less_than: 1440 },
            allow_nil: true

  scope :on_date, ->(date) { where(recorded_on: date) }
  scope :latest_first, -> { order(recorded_on: :desc, id: :desc) }

  def self.daily_total_for(user, date)
    user.exercise_entries.on_date(date).sum(:calories_burned)
  end
end
