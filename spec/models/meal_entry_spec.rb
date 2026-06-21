require "rails_helper"

RSpec.describe MealEntry, type: :model do
  fixtures :users, :meal_entries

  let(:user) { users(:one) }

  describe "バリデーション" do
    it "有効な属性で保存できる" do
      entry = user.meal_entries.build(recorded_on: Date.current, name: "ヨーグルト", calories: 120, quantity: 1)

      expect(entry).to be_valid
    end

    it "カロリーが必須" do
      entry = user.meal_entries.build(recorded_on: Date.current, name: "水", quantity: 1)

      expect(entry).not_to be_valid
    end

    it "個数が1未満なら無効" do
      entry = user.meal_entries.build(recorded_on: Date.current, name: "水", calories: 100, quantity: 0)

      expect(entry).not_to be_valid
    end

    it "同じ日に複数件保存できる" do
      expect {
        user.meal_entries.create!(recorded_on: Date.current, name: "追加", calories: 100, quantity: 1)
      }.to change(MealEntry, :count).by(1)
    end

    it "食事区分は任意" do
      entry = user.meal_entries.build(recorded_on: Date.current, name: "おにぎり", calories: 200, quantity: 1, meal_type: nil)

      expect(entry).to be_valid
    end
  end

  describe "#total_calories" do
    it "1個あたりのカロリーと個数の積を返す" do
      entry = meal_entries(:one_breakfast)

      expect(entry.total_calories).to eq(700)
    end
  end

  describe ".daily_total_for" do
    it "指定日の合計カロリーを返す" do
      total = MealEntry.daily_total_for(user, Date.current)

      expect(total).to eq(1150)
    end
  end

  describe ".average_daily_calories" do
    it "期間内の日次平均を返す" do
      average = MealEntry.average_daily_calories(
        user,
        from: Date.current - 1,
        to: Date.current
      )

      expect(average).to eq(975.0)
    end

    it "記録がなければ nil" do
      empty_user = users(:two)

      expect(
        MealEntry.average_daily_calories(empty_user, from: Date.current, to: Date.current)
      ).to be_nil
    end
  end
end
