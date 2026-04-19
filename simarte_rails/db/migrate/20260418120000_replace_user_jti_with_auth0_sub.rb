# frozen_string_literal: true

class ReplaceUserJtiWithAuth0Sub < ActiveRecord::Migration[8.1]
  def change
    remove_index :users, :jti
    remove_column :users, :jti, :string
    add_column :users, :auth0_sub, :string
    add_index :users, :auth0_sub, unique: true
  end
end
