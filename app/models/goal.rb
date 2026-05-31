class Goal < ApplicationRecord
  belongs_to :user

  validates :effective_on, presence: true, uniqueness: { scope: :user_id }
  validates :target_weight, numericality: { greater_than: 0, less_than: 500, allow_nil: true }
  validates :daily_calorie_target, numericality: { only_integer: true, greater_than: 0, less_than: 100_000, allow_nil: true }
  validate :must_have_at_least_one_target

  scope :latest_first, -> { order(effective_on: :desc, id: :desc) }

  private
    def must_have_at_least_one_target
      return if target_weight.present? || daily_calorie_target.present?

      errors.add(:base, :no_target)
    end
end
