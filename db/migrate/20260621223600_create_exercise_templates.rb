class CreateExerciseTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :exercise_templates do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :calories_burned, null: false
      t.integer :duration_minutes

      t.timestamps
    end

    add_index :exercise_templates, [ :user_id, :name ], unique: true
  end
end
