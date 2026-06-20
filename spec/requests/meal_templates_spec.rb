require "rails_helper"

RSpec.describe "食事テンプレート", type: :request do
  fixtures :users, :meal_templates

  let(:user) { users(:one) }
  let(:other_user) { users(:two) }
  let(:template) { meal_templates(:one_oatmeal) }

  describe "一覧" do
    it "ログイン後に一覧を表示できる" do
      sign_in_as(user)

      get meal_templates_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("オートミール")
    end
  end

  describe "作成" do
    it "テンプレートを作成できる" do
      sign_in_as(user)

      expect {
        post meal_templates_path, params: {
          meal_template: { name: "バナナ", calories: 90 }
        }
      }.to change(MealTemplate, :count).by(1)

      expect(response).to redirect_to(meal_templates_path)
    end
  end

  describe "更新" do
    it "他ユーザーのテンプレートは更新できない" do
      sign_in_as(other_user)

      patch meal_template_path(template), params: {
        meal_template: { name: "不正", calories: 1 }
      }

      expect(response).to have_http_status(:not_found)
      expect(template.reload.name).to eq("オートミール")
    end
  end
end
