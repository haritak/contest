class AddDescriptionToSchoolClass < ActiveRecord::Migration[7.1]
  def change
    add_column :school_classes, :description, :string, default: ""
  end
end
