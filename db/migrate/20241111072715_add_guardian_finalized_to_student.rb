class AddGuardianFinalizedToStudent < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :guardian, :string
    add_column :students, :finalized, :boolean, default: false
  end
end
