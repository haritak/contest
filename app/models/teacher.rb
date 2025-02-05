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
class RequireEmail < ActiveModel::Validator
  def validate(record)
    if record.person.contact_email.empty?
      record.errors.add :person, "Για τους εκπαιδευτικούς, απαιτείται ένα email επικοινωνίας"
    end
  end
end
class RequirePhone < ActiveModel::Validator
  def validate(record)
    if record.person.contact_phone.empty?
      record.errors.add :person, "Για τους εκπαιδευτικούς, απαιτείται ένα τηλέφωνο επικοινωνίας"
    end
  end
end

class Teacher < ApplicationRecord
  include IsAPerson

  belongs_to :speciality

  has_one :user, through: :person
  has_one :team, through: :user
  has_one :school, through: :team


  validates :gdpr_accepted, acceptance: true
  validates_with RequireEmail
  validates_with RequirePhone

  scope :with_email, ->(email) {joins(:person).where( person: {contact_email: email} ) }
  scope :finalized, ->{ where(finalized: true) }

  enum team_role: [:representative, :substitute, :member]
  def self.team_roles_translated
    {
      representative: "Βασικός εκπ. επικοινωνίας",
      substitute:     "Αναπληρ. εκπρ. επικ.", 
      member:         "Δεύτερος αναπληρ."
    }
  end

  scope :representative, ->{where(team_role: :representative)}
  scope :substitute, ->{where(team_role: :substitute)}
  scope :member, ->{where(team_role: :member)}

  def team_role_to_s
    Teacher.team_roles_translated[ team_role.to_sym ]
  end
end
