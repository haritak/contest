module IsAPerson
  extend ActiveSupport::Concern

  included do
    belongs_to :person
    has_one :user, through: :people
    scope :owned_by, ->(user) {joins(:person).where( person: {user: user} )}
    scope :by_email, ->(email) {joins(:person).where( person: {contact_email: email} ) }
  end

  def owned_by( this_user )
    person.owned_by this_user
  end
end

