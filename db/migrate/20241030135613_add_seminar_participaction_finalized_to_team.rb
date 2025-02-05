class AddSeminarParticipactionFinalizedToTeam < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :seminar_participation_finalized, :boolean, default: false
    add_column :teams, :seminar_participation_finalized_date, :datetime, default: nil
  end
end
