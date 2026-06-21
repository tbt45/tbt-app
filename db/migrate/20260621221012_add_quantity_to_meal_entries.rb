class AddQuantityToMealEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :meal_entries, :quantity, :integer, null: false, default: 1
  end
end
