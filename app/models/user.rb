class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :weight_entries, dependent: :destroy
  has_many :goals, dependent: :destroy

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
end
