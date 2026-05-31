class CreateWeightEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :weight_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.date :recorded_on, null: false
      t.decimal :weight, precision: 5, scale: 1, null: false
      t.decimal :body_fat_percentage, precision: 4, scale: 1

      t.timestamps
    end

    add_index :weight_entries, [ :user_id, :recorded_on ], unique: true
  end
end
