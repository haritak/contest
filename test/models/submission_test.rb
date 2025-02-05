# == Schema Information
#
# Table name: submissions
#
#  id                     :bigint           not null, primary key
#  finalized              :boolean          default(FALSE)
#  finalized_date         :datetime
#  reviewed               :boolean          default(FALSE)
#  reviewer_notes         :text(65535)
#  submission_description :text(65535)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  person_id              :bigint
#  submission_type_id     :bigint           not null
#  user_id                :bigint           not null
#
# Indexes
#
#  index_submissions_on_person_id           (person_id)
#  index_submissions_on_submission_type_id  (submission_type_id)
#  index_submissions_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (submission_type_id => submission_types.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class SubmissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
