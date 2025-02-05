class AddIsSecretaryToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :is_secretary, :boolean, default: false
  end
end
