class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :description
      t.references :user, null: false, foreign_key: true
      t.string :color
      t.boolean :is_global

      t.timestamps
    end
  end
end
