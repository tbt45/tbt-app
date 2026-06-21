class CreateExerciseEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :exercise_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.date :recorded_on, null: false
      t.string :name, null: false
      t.integer :calories_burned, null: false
      t.integer :duration_minutes

      t.timestamps
    end

    add_index :exercise_entries, [ :user_id, :recorded_on ]
  end
end
