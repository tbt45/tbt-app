class Session < ApplicationRecord
  DEFAULT_DURATION = 30.days
  REMEMBER_ME_DURATION = 90.days

  belongs_to :user

  scope :active, -> { where(expires_at: Time.current..) }

  def self.expires_at_for(remember_me:)
    duration = remember_me ? REMEMBER_ME_DURATION : DEFAULT_DURATION
    duration.from_now
  end

  def active?
    user.present? && expires_at.future?
  end

  def refresh_expiry!
    duration = remember_me ? REMEMBER_ME_DURATION : DEFAULT_DURATION
    update!(expires_at: duration.from_now)
  end
end
