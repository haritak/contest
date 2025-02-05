# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  failed_attempts        :integer          default(0), not null
#  is_admin               :boolean
#  is_reviewer            :boolean          default(FALSE)
#  is_secretary           :boolean          default(FALSE)
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string(255)
#  unlock_token           :string(255)
#  username               :string(100)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable,
         :trackable

  validates :password, presence: true, length: { minimum: 10, maximum: 128 }
  validate :password_complexity
  validates :email, presence: true

  scope :admins, ->{ where(is_admin: true) }
  scope :secretaries, ->{ where(is_secretary: true) }
  scope :no_team, ->{ left_outer_joins(:team).where(team: {id: nil}) }

  has_many :schools
  #has_many :teams
  has_one :team
  has_many :submissions
  has_many :people
  has_many :students, through: :people
  has_many :teachers, through: :people
  has_many :student_submissions, through: :students

  def password_complexity
    different_classes = 0
    different_classes += 1 if password =~ /[0-9]/
    different_classes += 1 if password =~ /[a-z]/
    different_classes += 1 if password =~ /[A-Z]/
    different_classes += 1 if password =~ /[\.\!\@\#\$\%\^\&\*\(\)\_\-\+\=]/

    errors.add(:password, "είναι πολύ απλός. Δοκιμάστε να προσθέσετε νούμερα, μικρά και κεφαλαία γράμματα.") if different_classes < 2
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end


  def is_regular?
    !is_admin? and !is_secretary? and !is_reviewer
  end

end
