require "rails_helper"

RSpec.describe MealTemplate, type: :model do
  fixtures :users, :meal_templates

  let(:user) { users(:one) }

  describe "バリデーション" do
    it "有効な属性で保存できる" do
      template = user.meal_templates.build(name: "バナナ", calories: 90)

      expect(template).to be_valid
    end

    it "同じ名前の重複を拒否する" do
      template = user.meal_templates.build(name: meal_templates(:one_oatmeal).name, calories: 100)

      expect(template).not_to be_valid
    end
  end
end
