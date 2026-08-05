require "rails_helper"

RSpec.describe User, type: :model do
  fixtures :users, :goals, :weight_entries, :meal_entries, :exercise_entries

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

  describe "#meal_calories_on" do
    it "指定日の合計カロリーを返す" do
      user = users(:one)

      expect(user.meal_calories_on(Date.current)).to eq(1150)
    end
  end

  describe "#calorie_gap_to_target" do
    it "目標カロリーとの差を返す" do
      user = users(:one)

      expect(user.calorie_gap_to_target(Date.current)).to eq(-850)
    end
  end

  describe "#calorie_balance_on" do
    it "摂取カロリーから消費カロリーを引いた値を返す" do
      user = users(:one)

      expect(user.calorie_balance_on(Date.current)).to eq(700)
    end
  end

  describe "#weight_series" do
    it "期間内の体重を日付順で返す" do
      user = users(:one)
      series = user.weight_series(from: Date.current - 1, to: Date.current)

      expect(series.map(&:first)).to eq([ Date.current - 1, Date.current ])
      expect(series.map { |_, weight| weight.to_f }).to eq([ 66.8, 66.5 ])
    end
  end

  describe "#recorded_dates_in" do
    it "食事・運動・体重のいずれかの記録がある日を返す" do
      user = users(:one)
      dates = user.recorded_dates_in(Date.current - 1..Date.current)

      expect(dates).to include(Date.current, Date.current - 1)
    end
  end
end
