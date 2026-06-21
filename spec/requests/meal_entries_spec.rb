require "rails_helper"

RSpec.describe "食事記録", type: :request do
  fixtures :users, :meal_entries, :meal_templates, :goals

  let(:user) { users(:one) }
  let(:other_user) { users(:two) }
  let(:entry) { meal_entries(:one_breakfast) }

  describe "一覧" do
    it "ログイン後に日別一覧を表示できる" do
      sign_in_as(user)

      get meal_entries_path, params: { date: Date.current }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("1150")
      expect(response.body).to include("オートミール")
      expect(response.body).to include("700")
    end

    it "未ログインではログイン画面へリダイレクトする" do
      get meal_entries_path

      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "サマリー" do
    it "日次合計と週月平均を表示できる" do
      sign_in_as(user)

      get summary_meal_entries_path, params: { date: Date.current }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("1150")
    end
  end

  describe "作成" do
    it "複数行の食事記録を一括作成できる" do
      sign_in_as(user)

      expect {
        post meal_entries_path, params: {
          meal_entry_batch: {
            recorded_on: Date.current,
            rows: [
              { name: "味噌汁", calories: 80, quantity: 1 },
              { name: "バナナ", calories: 90, quantity: 2 }
            ]
          }
        }
      }.to change(MealEntry, :count).by(2)

      expect(response).to redirect_to(meal_entries_path(date: Date.current))
      follow_redirect!
      expect(response.body).to include("2件の食事を記録しました")
    end

    it "テンプレート名とカロリーを指定して作成できる" do
      sign_in_as(user)
      template = meal_templates(:one_oatmeal)

      post meal_entries_path, params: {
        meal_entry_batch: {
          recorded_on: Date.current,
          rows: [ { name: template.name, calories: template.calories, quantity: 3 } ]
        }
      }

      created = MealEntry.order(:id).last
      expect(created.name).to eq(template.name)
      expect(created.calories).to eq(template.calories)
      expect(created.quantity).to eq(3)
      expect(created.total_calories).to eq(1050)
    end

    it "食事名が空の行だけなら作成しない" do
      sign_in_as(user)

      expect {
        post meal_entries_path, params: {
          meal_entry_batch: {
            recorded_on: Date.current,
            rows: [ { name: "", calories: "", quantity: 1 } ]
          }
        }
      }.not_to change(MealEntry, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "更新" do
    it "食事記録を更新できる" do
      sign_in_as(user)

      patch meal_entry_path(entry), params: {
        meal_entry: { recorded_on: entry.recorded_on, name: "更新後", calories: 400, quantity: 2, meal_type: entry.meal_type }
      }

      expect(response).to redirect_to(meal_entries_path(date: entry.recorded_on))
      expect(entry.reload.name).to eq("更新後")
      expect(entry.quantity).to eq(2)
    end

    it "他ユーザーの記録は更新できない" do
      sign_in_as(other_user)

      patch meal_entry_path(entry), params: {
        meal_entry: { recorded_on: entry.recorded_on, name: "不正", calories: 1, quantity: 1 }
      }

      expect(response).to have_http_status(:not_found)
      expect(entry.reload.name).to eq("オートミール")
    end
  end

  describe "削除" do
    it "食事記録を削除できる" do
      sign_in_as(user)

      expect {
        delete meal_entry_path(entry)
      }.to change(MealEntry, :count).by(-1)

      expect(response).to redirect_to(meal_entries_path(date: entry.recorded_on))
    end
  end
end
