class AddOptionalToSubmissionType < ActiveRecord::Migration[7.1]
  def change
    add_column :submission_types, :optional, :boolean, default: false
  end
end
