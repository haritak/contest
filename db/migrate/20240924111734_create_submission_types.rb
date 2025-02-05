class CreateSubmissionTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :submission_types do |t|
      t.string :submission_type

      t.timestamps
    end
  end
end
