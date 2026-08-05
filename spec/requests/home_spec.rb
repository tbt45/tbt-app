require "rails_helper"

RSpec.describe "ダッシュボード", type: :request do
  fixtures :users, :weight_entries, :goals, :meal_entries, :exercise_entries

  let(:user) { users(:one) }

  describe "表示" do
    it "ログイン後に今日のサマリー集計を表示できる" do
      sign_in_as(user)

      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("ダッシュボード")
      expect(response.body).to include("66.5")
      expect(response.body).to include("1150")
      expect(response.body).to include("450")
      expect(response.body).to include("700")
      expect(response.body).to include("2000")
    end

    it "日付を指定してサマリーを切り替えられる" do
      sign_in_as(user)
      yesterday = Date.current - 1

      get root_path, params: { date: yesterday }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("800")
      expect(response.body).to include("200")
      expect(response.body).to include("600")
    end

    it "週次のカロリーグラフに切り替えられる" do
      sign_in_as(user)

      get root_path, params: { calorie_period: "weekly" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("週次")
    end

    it "未ログインではログイン画面へリダイレクトする" do
      get root_path

      expect(response).to redirect_to(new_session_path)
    end
  end
end
