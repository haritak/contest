# == Schema Information
#
# Table name: specialities
#
#  id          :bigint           not null, primary key
#  code        :string(30)
#  description :string(200)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_specialities_on_code  (code) UNIQUE
#
require "test_helper"

class SpecialityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
