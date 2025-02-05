# == Schema Information
#
# Table name: people
#
#  id            :bigint           not null, primary key
#  contact_email :string(255)
#  contact_phone :string(255)
#  father_name   :string(255)
#  first_name    :string(255)
#  gender        :integer
#  last_name     :string(255)
#  mother_name   :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_people_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class NotAllCapitals < ActiveModel::Validator
  def validate(record)
    [:first_name, :last_name, :father_name, :mother_name].each do |method|
      value = record.send(method)
      no_capitals = 
        value.chars.collect {|c| ("ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ".include? c) ? c : nil}.compact.count
      if no_capitals > value.length/2
        record.errors.add method, "Παρακαλούμε να μην είναι όλα κεφαλαία."
      end
    end
  end
end

class Person < ApplicationRecord
  enum gender: [:male, :female]
  def male? =  gender == "male"
  def female? =  gender == "female"

  belongs_to :user

  has_one :teacher
  has_one :student
  has_many :sent_emails
  has_many :submissions


  def self.genders_translated
    {
      male: "Άρρεν",
      female: "Θήλυ"
    }
  end

  def gender_to_s
    Person.genders_translated[gender.to_sym]
  end


  def ==(other)
    first_name == other.first_name and last_name == other.last_name and
      father_name == other.father_name and mother_name == other.mother_name and
      id != other.id
  end
  

  validates :first_name, :last_name, :gender, presence: true
  validates :contact_phone, format: { with: /\A\+?[0-9]+\z/ }, allow_blank: true
  validates :contact_phone, length: { minimum: 10 }, allow_blank: true #διαφορετικό μήνυμα
  validates :contact_phone, length: { maximum: 10 }, allow_blank: true #διαφορετικό μήνυμα
  validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP } , allow_blank: true
  validates_with NotAllCapitals

  def to_s
    "#{short_name} #{father_name} #{mother_name}"
  end

  def short_name
    "#{last_name} #{first_name}"
  end

  def self.ton(gender)
    gender == "male" ? "τον" : "την"
  end

  def self.mathiti(gender)
    gender == "male" ? "μαθητή" : "μαθήτρια"
  end

  def self.mathitis(gender)
    gender == "male" ? "μαθητής" : "μαθήτρια"
  end

  def self.o_mathitis(gender)
    gender == "male" ? "ο μαθητής" : "η μαθήτρια"
  end

  def self.tou_mathiti(gender)
    gender == "male" ? "του μαθητή" : "της μαθήτριας"
  end

  def self.ton_mathiti(gender)
    gender == "male" ? "τον μαθητή" : "την μαθήτρια"
  end

  def self.o( gender )
    gender == "male" ? "ο" : "η"
  end

  def method_missing(method_name)

    if %i(ton mathiti mathitis o_mathitis tou_mathiti ton_mathiti o).include? method_name
      return Person.send(method_name, gender)
    end

    super
  end


end
