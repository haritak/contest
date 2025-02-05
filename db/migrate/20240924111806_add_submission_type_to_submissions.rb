class AddSubmissionTypeToSubmissions < ActiveRecord::Migration[7.1]
  def change
    add_reference :submissions, :submission_type, null: false, foreign_key: true
  end
end
