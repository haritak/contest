class DropColumnSchoolTypeFromSchool < ActiveRecord::Migration[7.1]
  def change
    remove_column :schools, :school_type
  end
end
