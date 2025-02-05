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
class MaxSubmissions < ActiveModel::Validator
  def validate(record)
    return if record.persisted?
    current_submission_type = record.submission_type
    return if not current_submission_type
    max_allowed = current_submission_type.max_submissions
    return if !max_allowed or max_allowed == -1

    current_user = record.user

    same_type_user_submissions = 
      current_user.submissions.where( submission_type: current_submission_type )

    if same_type_user_submissions.count >= max_allowed
      record.errors.add :submission_type, 
        "Έχει ήδη συμπληρωθεί ο μέγιστος επιτρεπόμενος " + 
        "αριθμός αρχείων (#{max_allowed}) αυτού του τύπου " + 
        "(#{current_submission_type.submission_type})"
    end
  end
end

class SubmissionFileType < ActiveModel::Validator
  def validate(record)
    current_submission_type = record.submission_type
    return if not current_submission_type
    accepted_filetype = current_submission_type.accepted_filetype
    return if not accepted_filetype
    return if accepted_filetype.empty?
    accepted_filetypes = accepted_filetype.split(",")
    current_file = record.submission_file
    return if not current_file
    return if not current_file.content_type


    if not accepted_filetypes.include? current_file.content_type
      record.errors.add :submission_file, "Μη αποδεκτός τύπος αρχείου (#{current_file.content_type}). Απαιτείται #{accepted_filetypes.join(" ή ")}"
    end
  end
end

class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :submission_type
  belongs_to :person, optional: true
  has_one_attached :submission_file

  has_one :team, through: :user
  has_one :school, through: :team
  has_many :teachers, through: :user
  has_many :persons, through: :teachers

  scope :optional, ->{ joins(:submission_type).where(submission_type:{optional: true}) }
  scope :mandatory, ->{ joins(:submission_type).where(submission_type:{optional: false}) }
  scope :finalized, ->{ where(finalized: true) }
  scope :not_finalized, ->{ where(finalized: false) }
  scope :reviewed, ->{ where(reviewed: true)}

  #validates :submission_file, presence: true, attached: true, content_type: "application/pdf", size: { less_than: 1.megabytes}
  validates :submission_file, presence: true, attached: true, size: { less_than: 50.megabytes}

  validates_with SubmissionFileType
  validates_with MaxSubmissions
end
