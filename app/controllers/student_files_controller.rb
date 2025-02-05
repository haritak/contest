class StudentFilesController < ApplicationController
  include Pundit::Authorization

  before_action :set_student_submission, only: %i[ show preview review_preview ]

  def show
    authorize @student_submission

    # only works when active storage stores files locally
    trgFn = ActiveStorage::Blob.service.path_for(@student_submission.file.key)

    send_file trgFn, filename: @student_submission.file.filename.to_s,
      disposition: "inline"
  end

  def preview
    authorize @student_submission

    @tags_to_show = Tag.of_user_or_global(current_user)
  end

  def review_preview
    authorize @student_submission

    @thumb_size = 200
    @thumb_size = params[:thumb_size].to_i if params[:thumb_size].present?

    @tags_to_show = Tag.of_user_or_global(current_user)
  end

  def set_thumbnail_size
    return if not params[:thumb_size]

    session[:thumb_size] = params[:thumb_size]

    redirect_back_or_to root_path
  end

  private

    def set_student_submission
      @student_submission = StudentSubmission.find(params[:id])
    end
end
