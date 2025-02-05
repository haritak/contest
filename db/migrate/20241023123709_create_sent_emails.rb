class CreateSentEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :sent_emails do |t|
      t.references :user, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.string :recipient_email, null: false
      t.string :description

      t.timestamps
    end
  end
end
