# == Schema Information
#
# Table name: submission_types
#
#  id                :bigint           not null, primary key
#  accepted_filetype :string(255)
#  description       :text(65535)
#  max_submissions   :integer          default(1)
#  optional          :boolean          default(FALSE)
#  submission_type   :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class SubmissionType < ApplicationRecord
  has_many :submissions

  scope :optional, ->{ where(optional:true) }
  scope :mandatory, ->{ where(optional:false) }

  # Πρέπει υποχρεωτικά να διαχωρίζεται μόνο με κόμμα όχι με ερωτηματικό
  # οπότε κάνουμε ένα έλεγχο στο ποιούς χαρακτήρες επιτρέπουμε
  validates :accepted_filetype, format: { with: /\A[a-z,-\/]+\z/ }
end
