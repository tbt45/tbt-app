class MealEntry < ApplicationRecord
  MEAL_TYPES = %w[breakfast lunch dinner snack].freeze

  belongs_to :user

  validates :recorded_on, presence: true
  validates :name, presence: true
  validates :calories, presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than: 100_000 }
  validates :meal_type, inclusion: { in: MEAL_TYPES, allow_blank: true }

  scope :on_date, ->(date) { where(recorded_on: date) }
  scope :latest_first, -> { order(recorded_on: :desc, id: :desc) }

  def self.daily_total_for(user, date)
    user.meal_entries.on_date(date).sum(:calories)
  end

  def self.daily_totals_for(user, from:, to:)
    user.meal_entries.where(recorded_on: from..to).group(:recorded_on).sum(:calories)
  end

  def self.average_daily_calories(user, from:, to:)
    totals = daily_totals_for(user, from: from, to: to)
    return nil if totals.empty?

    totals.values.sum.to_f / totals.size
  end
end
