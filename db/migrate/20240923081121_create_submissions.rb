class CreateSubmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :submissions do |t|
      t.text :submission_description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
