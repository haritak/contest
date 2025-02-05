# == Schema Information
#
# Table name: school_classes
#
#  id             :bigint           not null, primary key
#  description    :string(255)      default("")
#  school_class   :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  school_type_id :bigint
#
# Indexes
#
#  index_school_classes_on_school_type_id  (school_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (school_type_id => school_types.id)
#
class SchoolClass < ApplicationRecord
  belongs_to :school_type, optional: true
end
