class AddShutDownPreviewsAndEnableCoadminToSiteSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :site_settings, :shut_down_previews, :boolean, default: false
    add_column :site_settings, :enable_coadmin, :boolean, default: false
  end
end
