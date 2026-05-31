require "rails_helper"

RSpec.describe "体重記録", type: :request do
  fixtures :users, :weight_entries

  let(:user) { users(:one) }
  let(:other_user) { users(:two) }
  let(:entry) { weight_entries(:one_weight_today) }

  describe "一覧" do
    it "ログイン後に一覧を表示できる" do
      sign_in_as(user)

      get weight_entries_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("66.5")
    end

    it "未ログインではログイン画面へリダイレクトする" do
      get weight_entries_path

      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "作成" do
    it "体重記録を作成できる" do
      sign_in_as(user)

      expect {
        post weight_entries_path, params: {
          weight_entry: { recorded_on: Date.current - 2, weight: 65.0, body_fat_percentage: 19.0 }
        }
      }.to change(WeightEntry, :count).by(1)

      expect(response).to redirect_to(weight_entries_path)
    end

    it "同じ日付の重複を拒否する" do
      sign_in_as(user)

      expect {
        post weight_entries_path, params: {
          weight_entry: { recorded_on: entry.recorded_on, weight: 70.0 }
        }
      }.not_to change(WeightEntry, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "更新" do
    it "体重記録を更新できる" do
      sign_in_as(user)

      patch weight_entry_path(entry), params: {
        weight_entry: { recorded_on: entry.recorded_on, weight: 66.0 }
      }

      expect(response).to redirect_to(weight_entries_path)
      expect(entry.reload.weight).to eq(66.0)
    end

    it "他ユーザーの記録は更新できない" do
      sign_in_as(other_user)

      patch weight_entry_path(entry), params: {
        weight_entry: { recorded_on: entry.recorded_on, weight: 50.0 }
      }

      expect(response).to have_http_status(:not_found)
      expect(entry.reload.weight).to eq(66.5)
    end
  end

  describe "削除" do
    it "体重記録を削除できる" do
      sign_in_as(user)

      expect {
        delete weight_entry_path(entry)
      }.to change(WeightEntry, :count).by(-1)

      expect(response).to redirect_to(weight_entries_path)
    end

    it "他ユーザーの記録は削除できない" do
      sign_in_as(other_user)

      expect {
        delete weight_entry_path(entry)
      }.not_to change(WeightEntry, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
