class AddExpiresAtToSessions < ActiveRecord::Migration[8.1]
  def up
    add_column :sessions, :expires_at, :datetime
    add_column :sessions, :remember_me, :boolean, default: true, null: false

    execute <<~SQL.squish
      UPDATE sessions
      SET expires_at = DATE_ADD(created_at, INTERVAL 30 DAY),
          remember_me = TRUE
      WHERE expires_at IS NULL
    SQL

    change_column_null :sessions, :expires_at, false
    add_index :sessions, :expires_at

    Session.reset_column_information
    Session.find_each do |session|
      session.destroy unless User.exists?(session.user_id)
    end
  end

  def down
    remove_index :sessions, :expires_at
    remove_column :sessions, :remember_me
    remove_column :sessions, :expires_at
  end
end
