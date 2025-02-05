# == Schema Information
#
# Table name: sent_emails
#
#  id              :bigint           not null, primary key
#  description     :string(255)
#  recipient_email :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  person_id       :bigint
#  user_id         :bigint           not null
#
# Indexes
#
#  index_sent_emails_on_person_id  (person_id)
#  index_sent_emails_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class SentEmailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
