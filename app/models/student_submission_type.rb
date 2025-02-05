# == Schema Information
#
# Table name: student_submission_types
#
#  id                :bigint           not null, primary key
#  accepted_filetype :string(255)
#  description       :text(65535)
#  max_submissions   :integer
#  name              :string(255)
#  optional          :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class StudentSubmissionType < ApplicationRecord
  has_many :student_submissions

  scope :optional, ->{ where(optional:true) }
  scope :mandatory, ->{ where(optional:false) }

  # Πρέπει υποχρεωτικά να διαχωρίζεται μόνο με κόμμα όχι με ερωτηματικό
  # οπότε κάνουμε ένα έλεγχο στο ποιούς χαρακτήρες επιτρέπουμε
  validates :accepted_filetype, format: { with: /\A[a-z,-\/]+\z/ }
end
