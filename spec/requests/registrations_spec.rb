require "rails_helper"

RSpec.describe "新規登録", type: :request do
  fixtures :users

  describe "登録画面の表示" do
    it "成功する" do
      get new_registration_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "登録処理" do
    it "ユーザーを作成してログインする" do
      expect {
        post registration_path, params: {
          user: {
            email_address: "new@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(cookies[:session_id]).to be_present
    end

    it "重複メールアドレスを拒否する" do
      existing = users(:one)

      expect {
        post registration_path, params: {
          user: {
            email_address: existing.email_address,
            password: "password",
            password_confirmation: "password"
          }
        }
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("error_explanation")
    end

    it "不正な入力を拒否する" do
      expect {
        post registration_path, params: {
          user: {
            email_address: "invalid",
            password: "short",
            password_confirmation: "mismatch"
          }
        }
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("error_explanation")
    end
  end
end
