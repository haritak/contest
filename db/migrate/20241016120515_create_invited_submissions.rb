class CreateInvitedSubmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :invited_submissions do |t|
      t.references :submission, null: false, foreign_key: true
      t.references :invitation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
