require "rails_helper"

RSpec.describe WeightEntry, type: :model do
  fixtures :users, :weight_entries

  let(:user) { users(:one) }

  describe "バリデーション" do
    it "有効な属性で保存できる" do
      entry = user.weight_entries.build(recorded_on: Date.current - 2, weight: 65.0)
      expect(entry).to be_valid
    end

    it "体重が必須" do
      entry = user.weight_entries.build(recorded_on: Date.current - 2, weight: nil)
      expect(entry).not_to be_valid
    end

    it "同じ日付の重複を拒否する" do
      entry = user.weight_entries.build(recorded_on: weight_entries(:one_weight_today).recorded_on, weight: 70.0)
      expect(entry).not_to be_valid
      expect(entry.errors[:recorded_on]).to be_present
    end

    it "体脂肪率は任意" do
      entry = user.weight_entries.build(recorded_on: Date.current - 2, weight: 65.0, body_fat_percentage: nil)
      expect(entry).to be_valid
    end
  end
end
