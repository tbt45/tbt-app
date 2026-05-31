require "rails_helper"

RSpec.describe User, type: :model do
  fixtures :users, :goals, :weight_entries

  describe "メールアドレスの正規化" do
    it "前後の空白を除去して小文字に変換する" do
      user = User.new(email_address: "  Test@Example.COM  ", password: "password")
      expect(user.email_address).to eq("test@example.com")
    end
  end

  describe "#current_goal" do
    it "設定日が最新の目標を返す" do
      user = users(:one)
      older = user.goals.create!(effective_on: Date.current - 30, target_weight: 70.0)
      newer = user.goals.create!(effective_on: Date.current - 1, daily_calorie_target: 1800)

      expect(user.current_goal).to eq(newer)
      expect(user.current_goal).not_to eq(older)
    end
  end

  describe "#weight_gap_to_target" do
    it "最新体重と目標体重の差を返す" do
      user = users(:one)
      expect(user.weight_gap_to_target).to eq(1.5)
    end

    it "目標未設定なら nil" do
      user = users(:two)
      expect(user.weight_gap_to_target).to be_nil
    end
  end
end
