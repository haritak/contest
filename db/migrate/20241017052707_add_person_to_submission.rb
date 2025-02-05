class AddPersonToSubmission < ActiveRecord::Migration[7.1]
  def change
    add_reference :submissions, :person, null: true, foreign_key: true
  end
end
