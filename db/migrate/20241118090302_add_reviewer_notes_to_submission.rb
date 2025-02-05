class AddReviewerNotesToSubmission < ActiveRecord::Migration[7.1]
  def change
    add_column :submissions, :reviewer_notes, :text
  end
end
