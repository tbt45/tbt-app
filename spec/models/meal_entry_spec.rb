require "rails_helper"

RSpec.describe MealEntry, type: :model do
  fixtures :users, :meal_entries

  let(:user) { users(:one) }

  describe "バリデーション" do
    it "有効な属性で保存できる" do
      entry = user.meal_entries.build(recorded_on: Date.current, name: "ヨーグルト", calories: 120)

      expect(entry).to be_valid
    end

    it "カロリーが必須" do
      entry = user.meal_entries.build(recorded_on: Date.current, name: "水")

      expect(entry).not_to be_valid
    end

    it "同じ日に複数件保存できる" do
      expect {
        user.meal_entries.create!(recorded_on: Date.current, name: "追加", calories: 100)
      }.to change(MealEntry, :count).by(1)
    end

    it "食事区分は任意" do
      entry = user.meal_entries.build(recorded_on: Date.current, name: "おにぎり", calories: 200, meal_type: nil)

      expect(entry).to be_valid
    end
  end

  describe ".daily_total_for" do
    it "指定日の合計カロリーを返す" do
      total = MealEntry.daily_total_for(user, Date.current)

      expect(total).to eq(800)
    end
  end

  describe ".average_daily_calories" do
    it "期間内の日次平均を返す" do
      average = MealEntry.average_daily_calories(
        user,
        from: Date.current - 1,
        to: Date.current
      )

      expect(average).to eq(800.0)
    end

    it "記録がなければ nil" do
      empty_user = users(:two)

      expect(
        MealEntry.average_daily_calories(empty_user, from: Date.current, to: Date.current)
      ).to be_nil
    end
  end
end
