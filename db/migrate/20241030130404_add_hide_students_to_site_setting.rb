class AddHideStudentsToSiteSetting < ActiveRecord::Migration[7.1]
  def change
    add_column :site_settings, :hide_students, :boolean, default:false
  end
end
