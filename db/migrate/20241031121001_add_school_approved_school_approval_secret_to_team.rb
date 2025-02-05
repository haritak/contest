class AddSchoolApprovedSchoolApprovalSecretToTeam < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :school_approved, :boolean, default: false
    add_column :teams, :school_approval_secret, :string
  end
end
