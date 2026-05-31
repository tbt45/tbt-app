require "rails_helper"

RSpec.describe Goal, type: :model do
  fixtures :users, :goals

  let(:user) { users(:one) }

  describe "バリデーション" do
    it "有効な属性で保存できる" do
      goal = user.goals.build(effective_on: Date.current - 1, target_weight: 64.0)
      expect(goal).to be_valid
    end

    it "同じ日付の重複を拒否する" do
      goal = user.goals.build(
        effective_on: goals(:one_current).effective_on,
        target_weight: 70.0
      )
      expect(goal).not_to be_valid
    end

    it "目標体重とカロリーが両方空なら無効" do
      goal = user.goals.build(effective_on: Date.current - 1)
      expect(goal).not_to be_valid
      expect(goal.errors[:base]).to be_present
    end
  end
end
