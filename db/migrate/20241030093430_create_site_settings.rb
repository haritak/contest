class CreateSiteSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :site_settings do |t|
      t.string :site_name, null: false
      t.string :site_title, null: false
      t.boolean :allow_autonomous_submissions, default: false

      t.timestamps
    end
    add_index :site_settings, :site_name, unique: true
  end
end
