class AddAcceptToSubmissionType < ActiveRecord::Migration[7.1]
  def change
    add_column :submission_types, :accepted_filetype, :string
  end
end
