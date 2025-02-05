# == Schema Information
#
# Table name: student_submissions
#
#  id                         :bigint           not null, primary key
#  finalized                  :boolean          default(FALSE)
#  finalized_date             :datetime
#  notes                      :text(65535)
#  review_datetime            :datetime
#  review_marked_ok           :boolean          default(FALSE)
#  review_notes               :text(65535)
#  review_public              :boolean
#  title                      :string(255)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  review_user_id             :bigint
#  student_id                 :bigint           not null
#  student_submission_type_id :bigint           not null
#  user_id                    :bigint           not null
#
# Indexes
#
#  fk_rails_8da25c4bd6                                      (review_user_id)
#  index_student_submissions_on_student_id                  (student_id)
#  index_student_submissions_on_student_submission_type_id  (student_submission_type_id)
#  index_student_submissions_on_user_id                     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (review_user_id => users.id)
#  fk_rails_...  (student_id => students.id)
#  fk_rails_...  (student_submission_type_id => student_submission_types.id)
#  fk_rails_...  (user_id => users.id)
#
class MaxStudentSubmissions < ActiveModel::Validator
  def validate(record)
    return if record.persisted?
    current_student = record.student
    current_submission_type = record.student_submission_type
    return if not current_submission_type
    max_allowed = current_submission_type.max_submissions
    return if !max_allowed or max_allowed == -1

    same_type_student_submissions = current_student.
      student_submissions.where( student_submission_type: current_submission_type )

    if same_type_student_submissions.count >= max_allowed
      record.errors.add :student_submission_type, "Έχει ήδη συμπληρωθεί ο μέγιστος επιτρεπόμενος αριθμός αρχείων (#{max_allowed}) αυτού του τύπου (#{current_submission_type.name})"
    end
  end
end

class StudentSubmissionFileType < ActiveModel::Validator
  def validate(record)
    current_student = record.student
    current_submission_type = record.student_submission_type
    return if not current_submission_type
    accepted_filetype = current_submission_type.accepted_filetype
    return if not accepted_filetype
    return if accepted_filetype.empty?
    current_file = record.file
    return if not current_file
    return if not current_file.content_type


    if not accepted_filetype.include? current_file.content_type
      record.errors.add :file, "Μη αποδεκτός τύπος αρχείου (#{current_file.content_type}). Απαιτείται #{accepted_filetype}"
    end
  end
end

class TitleNotAllCapitals < ActiveModel::Validator
  def validate(record)
    [:title].each do |method|
      value = record.send(method)
      next if not value
      no_capitals = 
        value.chars.collect {|c| ("ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ".include? c) ? c : nil}.compact.count
      if no_capitals > value.length/2
        record.errors.add method, "Παρακαλούμε να μην είναι όλα κεφαλαία."
      end
    end
  end
end
class TitleOnlyForOptionals < ActiveModel::Validator
  def validate(record)
    subtype_optional = record.student_submission_type&.optional
    return if subtype_optional == nil
    if subtype_optional == true
      if !record.title or record.title.empty?
        record.errors.add :title, "#{record.student_submission_type.name}:Απαιτείται τίτλος"
      end
    end
  end
end

class StudentSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :student
  belongs_to :student_submission_type
  has_one_attached :file

  has_one :team, through: :user
  has_one :school, through: :team
  has_one :school_type, through: :school
  has_one :person, through: :student
  has_one :school_class, through: :student

  has_many :student_submission_user_tags
  has_many :tags, through: :student_submission_user_tags

  scope :ordered, ->{ order(student_submission_type_id: :asc) }
  scope :optional, ->{ joins(:student_submission_type).where(student_submission_type: {optional: true}) }
  scope :mandatory, ->{ joins(:student_submission_type).where(student_submission_type: {optional: false}) }
  scope :finalized, ->{ where(finalized: true) }
  scope :not_finalized, ->{ where(finalized: false) }

  scope :adult, ->{ joins(:student).where(student: {is_adult: true}) }
  scope :kid, ->{ joins(:student).where(student: {is_adult: false}) }
  scope :gymnasium, ->{ joins(:student).joins(:school_class).where(school_class: {school_type_id: 2}) } # 2 ΓΥΜΝΑΣΙΟ
  scope :lyceum, ->{ joins(:student).joins(:school_class).where(school_class: {school_type_id: 3}) } # 3 ΛΥΚΕΙΟ

  scope :spedu, ->{ joins(:school).where(school: {is_spedu: true}) }
  scope :girls, ->{ joins(:person).where(person: {gender: :female}) }
  scope :boys, ->{ joins(:person).where(person: {gender: :male}) }



  after_create :update_student_counters
  after_destroy :update_student_counters
  before_destroy :decrement_reviews_counter
  after_update :update_student_counters #finalized...

  #validates :submission_file, presence: true, attached: true, content_type: "application/pdf", size: { less_than: 1.megabytes}
  validates :file, presence: true, attached: true, size: { less_than: 25.megabytes}
  validates :file, attached: true, processable_image: true, if: [Proc.new { |ss| ss&.student_submission_type&.optional? }] 
  
  # 20241105 - Phone Call with Polychronis and Dimitra
  # Specs: 
  # * μέγεθος όχι μικρότερο από 2MB
  # * η μεγάλη πλευρά όχι μικρότερη από 3000pixel
  # Είπαμε με την Δήμητρα να μην μπει κόφτης αλλά να έχει warning 
  #validates :file, size: { greater_than: 2.megabyte }, if: [Proc.new { |ss| ss&.student_submission_type&.optional? }] 
    # dimension: { width: {min:3000}, height: {min:3000}}, if: [Proc.new { |ss| ss&.student_submission_type&.optional? }]

  validates_with MaxStudentSubmissions
  validates_with StudentSubmissionFileType
  validates_with TitleNotAllCapitals
  validates_with TitleOnlyForOptionals

  def optional?
    student_submission_type.optional?
  end
  def mandatory?
    not optional?
  end

  private
    def update_student_counters
      st = self.student
      st.mandatory_counter = st.student_submissions.mandatory.count
      st.optional_counter = st.student_submissions.optional.count
      st.finalized_counter = st.student_submissions.finalized.count
      st.save!
    end

    def decrement_reviews_counter
      if review_public?
        st = self.student
        st.reviews_counter -= 1 if st.reviews_counter > 0
        st.save!
      end
    end
end
