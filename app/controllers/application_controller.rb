class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :whatever_not_found
  rescue_from ActionController::InvalidAuthenticityToken, with: :please_login_again

  before_action :authenticate_user!

  before_action :set_site_setting

  private

  def please_login_again
    if current_user
      sign_out current_user
    end
    redirect_to root_path, notice: "Παρακαλώ συνδεθείτε ξανά"
  end

  def user_not_authorized
    flash[:alert] = "Άρνηση πρόσβασης!"
    redirect_back_or_to(root_path)
  end

  def whatever_not_found
    flash[:alert] = "Αυτό δεν μπόρεσε να βρεθεί..."
    redirect_back_or_to(root_path)
  end

  def set_site_setting
    @site_setting = SiteSetting.where(site_name: Rails.root.basename.to_s).first
  end

  # https://www.rubydoc.info/github/plataformatec/devise/Devise%2FControllers%2FHelpers:after_sign_in_path_for
  def after_sign_in_path_for(resource)
    root_path
    #stored_location_for(resource) ||
      #if resource.is_a?(User) && resource.can_publish?
        #publisher_url
      #else
        #super
      #end
  end

end
