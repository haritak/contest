class AddMandatoryAndOptionalCounterToStudent < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :mandatory_counter, :integer, default: 0
    add_column :students, :optional_counter, :integer, default: 0
  end
end
