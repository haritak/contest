class AddFinalizedToTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :finalized, :boolean, default: false
    add_column :teams, :finalized_date, :datetime
  end
end
