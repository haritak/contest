class AddAdultToStudent < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :is_adult, :boolean, default: false
  end
end
