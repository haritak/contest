class SentEmailsController < ApplicationController
  def index
    @sent_emails = SentEmail.all if current_user&.is_admin?
  end
end
