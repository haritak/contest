# == Schema Information
#
# Table name: generated_files
#
#  id         :bigint           not null, primary key
#  filename   :string(255)
#  purpose    :string(255)
#  status     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_generated_files_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class GeneratedFileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
