# == Schema Information
#
# Table name: tags
#
#  id          :bigint           not null, primary key
#  color       :string(255)
#  description :string(255)
#  is_global   :boolean
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_tags_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Tag < ApplicationRecord
  belongs_to :user
  has_many :student_submission_user_tags
  has_many :student_submissions, through: :student_submission_user_tags

  scope :of_user, ->(user) { where(user_id: user.id) }
  scope :global, ->{ where(is_global: true) }
  scope :of_user_or_global, ->(user) { where(is_global: true).or(Tag.where(user_id: user.id)) }
end
