# == Schema Information
#
# Table name: teachers
#
#  id             :bigint           not null, primary key
#  coadmin        :boolean          default(FALSE)
#  finalized      :boolean
#  finalized_date :datetime
#  gdpr_accepted  :boolean          default(FALSE)
#  team_role      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  person_id      :bigint           not null
#  speciality_id  :bigint
#
# Indexes
#
#  index_teachers_on_person_id      (person_id)
#  index_teachers_on_speciality_id  (speciality_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (speciality_id => specialities.id)
#
require "test_helper"

class TeacherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
