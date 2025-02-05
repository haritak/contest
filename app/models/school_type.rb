# == Schema Information
#
# Table name: school_types
#
#  id          :bigint           not null, primary key
#  school_type :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_school_types_on_school_type  (school_type) UNIQUE
#
class SchoolType < ApplicationRecord
  has_many :schools
end
