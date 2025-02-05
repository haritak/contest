class AddSchoolTypeToSchoolClass < ActiveRecord::Migration[7.1]
  def change
    add_reference :school_classes, :school_type, null: true, foreign_key: true
  end
end
