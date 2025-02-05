class CreateSchoolTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :school_types do |t|
      t.string :school_type

      t.timestamps
    end
    add_index :school_types, :school_type, unique: true
  end
end
