class AddNamesToUsers < ActiveRecord::Migration[8.1]
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    execute <<-SQL.squish
      UPDATE users
      SET first_name = COALESCE(NULLIF(trim(split_part(email, '@', 1)), ''), 'User'),
          last_name = 'User'
      WHERE first_name IS NULL;
    SQL

    change_column_null :users, :first_name, false
    change_column_null :users, :last_name, false
  end

  def down
    remove_column :users, :first_name
    remove_column :users, :last_name
  end
end
