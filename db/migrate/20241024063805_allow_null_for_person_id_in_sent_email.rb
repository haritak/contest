class AllowNullForPersonIdInSentEmail < ActiveRecord::Migration[7.1]
  def change
    change_column_null :sent_emails, :person_id, true
  end
end
