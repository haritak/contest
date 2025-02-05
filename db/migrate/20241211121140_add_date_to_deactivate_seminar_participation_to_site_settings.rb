class AddDateToDeactivateSeminarParticipationToSiteSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :site_settings, :date_to_deactivate_seminar_participation, :datetime
  end
end
