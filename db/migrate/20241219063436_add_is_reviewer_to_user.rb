class AddIsReviewerToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :is_reviewer, :boolean, default: false
  end
end
