require "rails_helper"

RSpec.describe "目標管理", type: :request do
  fixtures :users, :goals, :weight_entries

  let(:user) { users(:one) }

  describe "現在の目標の表示" do
    it "ログイン後に最新の目標を表示できる" do
      sign_in_as(user)

      get goal_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("65.0")
      expect(response.body).to include("2000")
    end

    it "未ログインではログイン画面へリダイレクトする" do
      get goal_path

      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "目標の作成" do
    it "新しい目標を設定できる" do
      sign_in_as(users(:two))

      expect {
        post goal_path, params: {
          goal: { effective_on: Date.current, target_weight: 60.0, daily_calorie_target: 1700 }
        }
      }.to change(Goal, :count).by(1)

      expect(response).to redirect_to(goal_path)
    end

    it "不正な値を拒否する" do
      sign_in_as(user)

      expect {
        post goal_path, params: {
          goal: { effective_on: goals(:one_current).effective_on, target_weight: nil, daily_calorie_target: nil }
        }
      }.not_to change(Goal, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "目標の更新" do
    it "最新の目標を更新できる" do
      sign_in_as(user)

      patch goal_path, params: {
        goal: { effective_on: goals(:one_current).effective_on, target_weight: 64.0, daily_calorie_target: 1800 }
      }

      expect(response).to redirect_to(goal_path)
      expect(goals(:one_current).reload.target_weight).to eq(64.0)
    end
  end

  describe "目標の履歴" do
    it "一覧を表示できる" do
      sign_in_as(user)

      get goals_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("65.0")
    end
  end
end
