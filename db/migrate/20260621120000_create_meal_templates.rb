class CreateMealTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :meal_templates do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :calories, null: false

      t.timestamps
    end

    add_index :meal_templates, [ :user_id, :name ], unique: true
  end
end
