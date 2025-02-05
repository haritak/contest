# == Schema Information
#
# Table name: students
#
#  id                :bigint           not null, primary key
#  finalized         :boolean          default(FALSE)
#  finalized_counter :integer          default(0)
#  guardian          :string(255)
#  is_adult          :boolean          default(FALSE)
#  mandatory_counter :integer          default(0)
#  optional_counter  :integer          default(0)
#  reviews_counter   :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  person_id         :bigint           not null
#  school_class_id   :bigint           not null
#
# Indexes
#
#  index_students_on_person_id        (person_id)
#  index_students_on_school_class_id  (school_class_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (school_class_id => school_classes.id)
#
#  person_id        (person_id => people.id)
#  school_class_id  (school_class_id => school_classes.id)
class DoubleStudentValidator < ActiveModel::Validator
  def validate(current_student)
    user = current_student.person.user
    current_person = current_student.person

    user.students.each do |st|
      other_student = st
      other_person = other_student.person
      if other_person == current_person and 
          current_student.school_class == other_student.school_class
          current_student.errors.add :person, "Έχετε ήδη μαθητή/μαθήτρια με αυτά τα στοιχεία."
          break
      end
    end
  end
end

class Student < ApplicationRecord
  belongs_to :person
  belongs_to :school_class

  has_one :invitation
  has_many :student_submissions
  has_many :student_submission_types, through: :student_submissions
  has_many :student_submission_user_tags
  has_many :tags, through: :student_submission_user_tags
  has_one :school_type, through: :school_class

  has_one :user, through: :person
  has_one :team, through: :user
  has_one :school, through: :team

  scope :adults, ->{ where(is_adult: true) }
  scope :kids, ->{ where(is_adult: false) }
  scope :gymnasio, ->{ joins(:school_class, :school_type).where( "school_type LIKE '%ΓΥΜΝΑΣΙΟ%'" ) }
  scope :lykeio, ->{ joins(:school_class, :school_type).where( "school_type LIKE '%ΛΥΚΕΙΟ%'" ) }

  validates_with DoubleStudentValidator

  def adult_to_s
    if is_adult?
      return person.female? ? "ενήλικη" : "ενήλικος"
    end
    ""
  end
end
