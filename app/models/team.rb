# == Schema Information
#
# Table name: teams
#
#  id                                   :bigint           not null, primary key
#  contact_email                        :string(255)
#  contact_phone                        :string(255)
#  finalized                            :boolean          default(FALSE)
#  finalized_date                       :datetime
#  nickname                             :string(255)
#  participation_finalized              :boolean          default(FALSE)
#  participation_finalized_date         :datetime
#  school_approval_secret               :string(255)
#  school_approved                      :boolean          default(FALSE)
#  seminar_participation_finalized      :boolean          default(FALSE)
#  seminar_participation_finalized_date :datetime
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  school_id                            :bigint           not null
#  user_id                              :bigint           not null
#
# Indexes
#
#  index_teams_on_school_id  (school_id)
#  index_teams_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (school_id => schools.id)
#  fk_rails_...  (user_id => users.id)
#
class Team < ApplicationRecord
  belongs_to :user
  belongs_to :school

  scope :finalized, ->{ where(finalized: true) }
  scope :not_finalized, ->{ where(finalized: false) }

  scope :participation_finalized, ->{ where(participation_finalized: true) }
  scope :participation_not_finalized, ->{ where(participation_finalized: false) }
  scope :seminar_participation_finalized, ->{ where(seminar_participation_finalized: true) }
  scope :seminar_participation_not_finalized, ->{ where(seminar_participation_finalized: false) }

  #validates :nickname, uniqueness: true, presence: true
  validates :user, uniqueness: true
  validates :school, uniqueness: true
  validates :contact_phone, format: { with: /\A\+?[0-9]+\z/ }
  validates :contact_phone, length: { minimum: 10 }
  validates :contact_phone, length: { maximum: 10 }
  validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
