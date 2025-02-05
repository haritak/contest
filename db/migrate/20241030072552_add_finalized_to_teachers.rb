class AddFinalizedToTeachers < ActiveRecord::Migration[7.1]
  def change
    add_column :teachers, :finalized, :boolean
    add_column :teachers, :finalized_date, :datetime
  end
end
