class AddFinalizeToSubmissions < ActiveRecord::Migration[7.1]
  def change
    add_column :submissions, :finalized, :boolean, default: false
    add_column :submissions, :finalized_date, :datetime
  end
end
