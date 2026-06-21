class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :weight_entries, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :meal_entries, dependent: :destroy
  has_many :meal_templates, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { password.present? }

  def current_goal
    goals.latest_first.first
  end

  def latest_weight_entry
    weight_entries.order(recorded_on: :desc).first
  end

  def weight_gap_to_target
    return nil unless current_goal&.target_weight && latest_weight_entry

    latest_weight_entry.weight - current_goal.target_weight
  end

  def meal_calories_on(date)
    meal_entries.on_date(date).sum(Arel.sql("calories * quantity"))
  end

  def meal_weekly_average(anchor_date = Date.current)
    range = anchor_date.beginning_of_week..anchor_date.end_of_week
    MealEntry.average_daily_calories(self, from: range.begin, to: range.end)
  end

  def meal_monthly_average(anchor_date = Date.current)
    range = anchor_date.beginning_of_month..anchor_date.end_of_month
    MealEntry.average_daily_calories(self, from: range.begin, to: range.end)
  end

  def calorie_gap_to_target(date = Date.current)
    return nil unless current_goal&.daily_calorie_target

    meal_calories_on(date) - current_goal.daily_calorie_target
  end
end
