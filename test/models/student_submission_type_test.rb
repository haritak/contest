# == Schema Information
#
# Table name: student_submission_types
#
#  id                :bigint           not null, primary key
#  accepted_filetype :string(255)
#  description       :text(65535)
#  max_submissions   :integer
#  name              :string(255)
#  optional          :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require "test_helper"

class StudentSubmissionTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
