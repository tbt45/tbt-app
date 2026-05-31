require "rails_helper"

RSpec.describe Session, type: :model do
  fixtures :users

  let(:user) { users(:one) }

  describe "#active?" do
    it "有効期限内なら true" do
      session = user.sessions.create!(expires_at: 1.day.from_now, remember_me: false)

      expect(session).to be_active
    end

    it "期限切れなら false" do
      session = user.sessions.create!(expires_at: 1.minute.ago, remember_me: false)

      expect(session).not_to be_active
    end
  end

  describe "#refresh_expiry!" do
    it "remember_me なら 90 日後に延長する" do
      session = user.sessions.create!(expires_at: 1.day.from_now, remember_me: true)

      session.refresh_expiry!

      expect(session.expires_at).to be_within(1.minute).of(90.days.from_now)
    end
  end
end
