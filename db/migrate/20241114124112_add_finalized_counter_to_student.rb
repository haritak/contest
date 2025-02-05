class AddFinalizedCounterToStudent < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :finalized_counter, :integer, default: 0
  end
end
