require "rails_helper"

RSpec.describe "ログイン", type: :request do
  fixtures :users

  let(:user) { users(:one) }

  describe "ログイン画面の表示" do
    it "成功する" do
      get new_session_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "ログイン処理" do
    it "有効な認証情報でログインできる" do
      post session_path, params: { email_address: user.email_address, password: "password" }

      expect(response).to redirect_to(root_path)
      expect(cookies[:session_id]).to be_present
    end

    it "無効な認証情報を拒否する" do
      post session_path, params: { email_address: user.email_address, password: "wrong" }

      expect(response).to redirect_to(new_session_path)
      expect(cookies[:session_id]).to be_blank
    end
  end

  describe "ログアウト" do
    it "ログアウトできる" do
      sign_in_as(user)

      delete session_path

      expect(response).to redirect_to(new_session_path)
      expect(cookies[:session_id]).to be_blank
    end
  end

  describe "無効なセッション" do
    it "ユーザーが存在しないセッション Cookie ではログイン画面へリダイレクトする" do
      session = user.sessions.create!
      cookies[:session_id] = ActionDispatch::TestRequest.create.cookie_jar.tap { |jar|
        jar.signed[:session_id] = session.id
      }[:session_id]
      user.destroy!

      get root_path

      expect(response).to redirect_to(new_session_path)
    end
  end
end
