class CreateMealEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :meal_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.date :recorded_on, null: false
      t.string :name, null: false
      t.integer :calories, null: false
      t.string :meal_type

      t.timestamps
    end

    add_index :meal_entries, [ :user_id, :recorded_on ]
  end
end
