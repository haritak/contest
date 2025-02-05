class AddAcceptGdprToTeachers < ActiveRecord::Migration[7.1]
  def change
    add_column :teachers, :gdpr_accepted, :boolean, default: false
  end
end
