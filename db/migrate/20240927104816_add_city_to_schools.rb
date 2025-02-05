class AddCityToSchools < ActiveRecord::Migration[7.1]
  def change
    add_column :schools, :city, :string
  end
end
