# == Schema Information
#
# Table name: invitations
#
#  id                 :bigint           not null, primary key
#  active             :boolean
#  link               :string(2048)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  student_id         :bigint           not null
#  submission_type_id :bigint
#  user_id            :bigint           not null
#
# Indexes
#
#  index_invitations_on_student_id          (student_id)
#  index_invitations_on_submission_type_id  (submission_type_id)
#  index_invitations_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (student_id => students.id)
#  fk_rails_...  (submission_type_id => submission_types.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class InvitationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
