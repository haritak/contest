class AddReviewedToSubmission < ActiveRecord::Migration[7.1]
  def change
    add_column :submissions, :reviewed, :boolean, default: false
  end
end
