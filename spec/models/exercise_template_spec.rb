require "rails_helper"

RSpec.describe ExerciseTemplate, type: :model do
  fixtures :users, :exercise_templates

  let(:user) { users(:one) }

  describe "バリデーション" do
    it "有効な属性で保存できる" do
      template = user.exercise_templates.build(name: "ピラティス", calories_burned: 180)

      expect(template).to be_valid
    end

    it "同じ名前の重複を拒否する" do
      template = user.exercise_templates.build(name: "ジョギング", calories_burned: 100)

      expect(template).not_to be_valid
    end
  end
end
