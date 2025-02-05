class ChangeIndexOnNameForSchools < ActiveRecord::Migration[7.1]
  def change
    remove_index  :schools, :name
  end
end
