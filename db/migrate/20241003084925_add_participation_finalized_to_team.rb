class AddParticipationFinalizedToTeam < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :participation_finalized, :boolean, default: false
    add_column :teams, :participation_finalized_date, :datetime, default: nil
  end
end
