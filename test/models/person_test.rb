# == Schema Information
#
# Table name: people
#
#  id            :bigint           not null, primary key
#  contact_email :string(255)
#  contact_phone :string(255)
#  father_name   :string(255)
#  first_name    :string(255)
#  gender        :integer
#  last_name     :string(255)
#  mother_name   :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_people_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
