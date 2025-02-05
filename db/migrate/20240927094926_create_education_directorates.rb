class CreateEducationDirectorates < ActiveRecord::Migration[7.1]
  def change
    create_table :education_directorates do |t|
      t.string :name

      t.timestamps
    end
    add_index :education_directorates, :name, unique: true
  end
end
