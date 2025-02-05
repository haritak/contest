class AddIsSpeduToSchools < ActiveRecord::Migration[7.1]
  def change
    add_column :schools, :is_spedu, :boolean, default: false
  end
end
