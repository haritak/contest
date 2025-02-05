# == Schema Information
#
# Table name: submission_types
#
#  id                :bigint           not null, primary key
#  accepted_filetype :string(255)
#  description       :text(65535)
#  max_submissions   :integer          default(1)
#  optional          :boolean          default(FALSE)
#  submission_type   :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require "test_helper"

class SubmissionTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
