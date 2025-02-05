# == Schema Information
#
# Table name: schools
#
#  id                       :bigint           not null, primary key
#  city                     :string(255)
#  contact_email            :string(255)
#  contact_phone            :string(255)
#  is_spedu                 :boolean          default(FALSE)
#  name                     :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  education_directorate_id :bigint           not null
#  school_type_id           :bigint           not null
#  user_id                  :bigint           not null
#
# Indexes
#
#  index_schools_on_education_directorate_id  (education_directorate_id)
#  index_schools_on_school_type_id            (school_type_id)
#  index_schools_on_user_id                   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (education_directorate_id => education_directorates.id)
#  fk_rails_...  (school_type_id => school_types.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class SchoolTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
