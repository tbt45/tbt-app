require "rails_helper"

RSpec.describe "運動記録", type: :request do
  fixtures :users, :exercise_entries, :exercise_templates

  let(:user) { users(:one) }
  let(:other_user) { users(:two) }
  let(:entry) { exercise_entries(:one_running) }

  describe "一覧" do
    it "ログイン後に日別一覧を表示できる" do
      sign_in_as(user)

      get exercise_entries_path, params: { date: Date.current }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("450")
      expect(response.body).to include("ランニング")
    end

    it "未ログインではログイン画面へリダイレクトする" do
      get exercise_entries_path

      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "作成" do
    it "複数行の運動記録を一括作成できる" do
      sign_in_as(user)

      expect {
        post exercise_entries_path, params: {
          exercise_entry_batch: {
            recorded_on: Date.current,
            rows: [
              { name: "サイクリング", calories_burned: 200, duration_minutes: 20 },
              { name: "ストレッチ", calories_burned: 50 }
            ]
          }
        }
      }.to change(ExerciseEntry, :count).by(2)

      expect(response).to redirect_to(exercise_entries_path(date: Date.current))
      follow_redirect!
      expect(response.body).to include("2件の運動を記録しました")
    end

    it "テンプレート名とカロリーを指定して作成できる" do
      sign_in_as(user)
      template = exercise_templates(:one_jogging)

      post exercise_entries_path, params: {
        exercise_entry_batch: {
          recorded_on: Date.current,
          rows: [
            {
              name: template.name,
              calories_burned: template.calories_burned,
              duration_minutes: template.duration_minutes
            }
          ]
        }
      }

      created = ExerciseEntry.order(:id).last
      expect(created.name).to eq(template.name)
      expect(created.calories_burned).to eq(template.calories_burned)
      expect(created.duration_minutes).to eq(template.duration_minutes)
    end

    it "運動名が空の行だけなら作成しない" do
      sign_in_as(user)

      expect {
        post exercise_entries_path, params: {
          exercise_entry_batch: {
            recorded_on: Date.current,
            rows: [ { name: "", calories_burned: "" } ]
          }
        }
      }.not_to change(ExerciseEntry, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "更新" do
    it "運動記録を更新できる" do
      sign_in_as(user)

      patch exercise_entry_path(entry), params: {
        exercise_entry: {
          recorded_on: entry.recorded_on,
          name: "早朝ランニング",
          calories_burned: 350,
          duration_minutes: 35
        }
      }

      expect(response).to redirect_to(exercise_entries_path(date: entry.recorded_on))
      expect(entry.reload.name).to eq("早朝ランニング")
    end

    it "他ユーザーの記録は更新できない" do
      sign_in_as(other_user)

      patch exercise_entry_path(entry), params: {
        exercise_entry: {
          recorded_on: entry.recorded_on,
          name: "不正",
          calories_burned: 1
        }
      }

      expect(response).to have_http_status(:not_found)
      expect(entry.reload.name).to eq("ランニング")
    end
  end

  describe "削除" do
    it "運動記録を削除できる" do
      sign_in_as(user)

      expect {
        delete exercise_entry_path(entry)
      }.to change(ExerciseEntry, :count).by(-1)

      expect(response).to redirect_to(exercise_entries_path(date: entry.recorded_on))
    end
  end
end
