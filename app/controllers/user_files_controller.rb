class UserFilesController < ApplicationController
  include Pundit::Authorization

  before_action :set_submission, only: %i[ show ]

  def show
    authorize @submission
    # not that secure: redirect_to url_for(@submission.submission_file)
    # since the url is being displayed at the browser

    # only works when active storage stores files locally
    trgFn = ActiveStorage::Blob.service.path_for(@submission.submission_file.key)

    send_file trgFn, filename: @submission.submission_file.filename.to_s,
      disposition: "inline"
  end

  private

    def set_submission
      @submission = Submission.find(params[:id])
    end
end
