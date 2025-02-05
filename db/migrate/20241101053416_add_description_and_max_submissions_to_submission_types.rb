class AddDescriptionAndMaxSubmissionsToSubmissionTypes < ActiveRecord::Migration[7.1]
  def change
    add_column :submission_types, :description, :text, default: nil
    add_column :submission_types, :max_submissions, :integer, default: 1
  end
end
