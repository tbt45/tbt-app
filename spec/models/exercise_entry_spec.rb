require "rails_helper"

RSpec.describe ExerciseEntry, type: :model do
  fixtures :users, :exercise_entries

  let(:user) { users(:one) }

  describe "バリデーション" do
    it "有効な属性で保存できる" do
      entry = user.exercise_entries.build(
        recorded_on: Date.current,
        name: "サイクリング",
        calories_burned: 250,
        duration_minutes: 40
      )

      expect(entry).to be_valid
    end

    it "消費カロリーが必須" do
      entry = user.exercise_entries.build(recorded_on: Date.current, name: "ストレッチ")

      expect(entry).not_to be_valid
    end

    it "同じ日に複数件保存できる" do
      expect {
        user.exercise_entries.create!(recorded_on: Date.current, name: "追加", calories_burned: 100)
      }.to change(ExerciseEntry, :count).by(1)
    end

    it "時間（分）は任意" do
      entry = user.exercise_entries.build(
        recorded_on: Date.current,
        name: "ストレッチ",
        calories_burned: 50,
        duration_minutes: nil
      )

      expect(entry).to be_valid
    end
  end

  describe ".daily_total_for" do
    it "指定日の合計消費カロリーを返す" do
      total = ExerciseEntry.daily_total_for(user, Date.current)

      expect(total).to eq(450)
    end
  end
end
