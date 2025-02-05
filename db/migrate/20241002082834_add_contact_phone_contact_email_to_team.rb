class AddContactPhoneContactEmailToTeam < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :contact_phone, :string
    add_column :teams, :contact_email, :string
  end
end
