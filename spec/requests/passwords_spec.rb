require "rails_helper"

RSpec.describe "パスワードリセット", type: :request do
  fixtures :users

  let(:user) { users(:one) }

  describe "リセット申請画面の表示" do
    it "成功する" do
      get new_password_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "リセット申請" do
    it "登録済みユーザーにリセットメールを送信する" do
      expect {
        post passwords_path, params: { email_address: user.email_address }
      }.to have_enqueued_mail(PasswordsMailer, :reset).with(user)

      expect(response).to redirect_to(new_session_path)
      follow_redirect!
      expect(response.body).to include(I18n.t("passwords.create.notice"))
    end

    it "未登録メールアドレスではメールを送信せずリダイレクトする" do
      expect {
        post passwords_path, params: { email_address: "missing-user@example.com" }
      }.not_to have_enqueued_mail(PasswordsMailer, :reset)

      expect(response).to redirect_to(new_session_path)
      follow_redirect!
      expect(response.body).to include(I18n.t("passwords.create.notice"))
    end
  end

  describe "パスワード更新画面の表示" do
    it "有効なトークンで成功する" do
      get edit_password_path(user.password_reset_token)
      expect(response).to have_http_status(:ok)
    end

    it "無効なトークンではリダイレクトする" do
      get edit_password_path("invalid token")

      expect(response).to redirect_to(new_password_path)
      follow_redirect!
      expect(response.body).to include(I18n.t("passwords.invalid_token"))
    end
  end

  describe "パスワード更新" do
    it "パスワードを更新する" do
      expect {
        put password_path(user.password_reset_token), params: {
          password: "newpassword",
          password_confirmation: "newpassword"
        }
      }.to change { user.reload.password_digest }

      expect(response).to redirect_to(new_session_path)
      follow_redirect!
      expect(response.body).to include(I18n.t("passwords.update.notice"))
    end

    it "確認用パスワード不一致を拒否する" do
      token = user.password_reset_token

      expect {
        put password_path(token), params: {
          password: "password1",
          password_confirmation: "password2"
        }
      }.not_to change { user.reload.password_digest }

      expect(response).to redirect_to(edit_password_path(token))
      follow_redirect!
      expect(response.body).to include(I18n.t("passwords.update.mismatch"))
    end
  end
end
