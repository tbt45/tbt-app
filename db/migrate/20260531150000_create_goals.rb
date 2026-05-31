class CreateGoals < ActiveRecord::Migration[8.1]
  def change
    create_table :goals do |t|
      t.references :user, null: false, foreign_key: true
      t.date :effective_on, null: false
      t.decimal :target_weight, precision: 5, scale: 1
      t.integer :daily_calorie_target

      t.timestamps
    end

    add_index :goals, [ :user_id, :effective_on ], unique: true
  end
end
