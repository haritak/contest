class AddSchoolTypeToSchools < ActiveRecord::Migration[7.1]
  def change
    add_reference :schools, :school_type, null: false, foreign_key: true
  end
end
