# == Schema Information
#
# Table name: student_submission_user_tags
#
#  id                    :bigint           not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  student_submission_id :bigint           not null
#  tag_id                :bigint           not null
#  user_id               :bigint           not null
#
# Indexes
#
#  index_student_submission_user_tags_on_student_submission_id  (student_submission_id)
#  index_student_submission_user_tags_on_tag_id                 (tag_id)
#  index_student_submission_user_tags_on_user_id                (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (student_submission_id => student_submissions.id)
#  fk_rails_...  (tag_id => tags.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class StudentSubmissionUserTagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
