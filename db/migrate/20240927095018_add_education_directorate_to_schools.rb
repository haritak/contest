class AddEducationDirectorateToSchools < ActiveRecord::Migration[7.1]
  def change
    add_reference :schools, :education_directorate, null: false, foreign_key: true
  end
end
