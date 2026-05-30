require "rails_helper"

RSpec.describe User, type: :model do
  describe "メールアドレスの正規化" do
    it "前後の空白を除去して小文字に変換する" do
      user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
      expect(user.email_address).to eq("downcased@example.com")
    end
  end
end
