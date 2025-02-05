class CreateGeneratedFiles < ActiveRecord::Migration[7.1]
  def change
    create_table :generated_files do |t|
      t.references :user, null: false, foreign_key: true
      t.string :purpose
      t.string :status
      t.string :filename

      t.timestamps
    end
  end
end
