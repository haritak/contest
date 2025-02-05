class AddCoadminToTeacher < ActiveRecord::Migration[7.1]
  def change
    add_column :teachers, :coadmin, :boolean, default: false
  end
end
