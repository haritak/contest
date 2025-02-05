class AddReviewNotesCounterToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :reviews_counter, :integer, default: 0
  end
end
