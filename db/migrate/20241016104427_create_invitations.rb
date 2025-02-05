class CreateInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :invitations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.string :link, limit: 2048
      t.boolean :active
      t.references :submission_type, null: true, foreign_key: true

      t.timestamps
    end
  end
end
