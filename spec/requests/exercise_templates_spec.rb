require "rails_helper"

RSpec.describe "運動テンプレート", type: :request do
  fixtures :users, :exercise_templates

  let(:user) { users(:one) }
  let(:other_user) { users(:two) }
  let(:template) { exercise_templates(:one_jogging) }

  describe "一覧" do
    it "ログイン後に一覧を表示できる" do
      sign_in_as(user)

      get exercise_templates_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("ジョギング")
    end
  end

  describe "作成" do
    it "テンプレートを作成できる" do
      sign_in_as(user)

      expect {
        post exercise_templates_path, params: {
          exercise_template: { name: "サイクリング", calories_burned: 250, duration_minutes: 45 }
        }
      }.to change(ExerciseTemplate, :count).by(1)

      expect(response).to redirect_to(exercise_templates_path)
    end
  end

  describe "更新" do
    it "他ユーザーのテンプレートは更新できない" do
      sign_in_as(other_user)

      patch exercise_template_path(template), params: {
        exercise_template: { name: "不正", calories_burned: 1 }
      }

      expect(response).to have_http_status(:not_found)
      expect(template.reload.name).to eq("ジョギング")
    end
  end
end
