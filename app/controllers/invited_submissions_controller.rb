class InvitedSubmissionsController < ApplicationController

  skip_before_action :authenticate_user!
  before_action :check_site_autonomous_submission
  before_action :set_invited_submission, only: %i[ show edit update destroy ]

  # GET /invited_submissions or /invited_submissions.json
  def index
    if not params[:secret_url_part]
      redirect_to root_path, alert: "Invalid invitation link!"
      return
    end

    @invitation = Invitation.find_by(link: params[:secret_url_part])
    if not @invitation or !@invitation.active?
      redirect_to root_path, alert: "Δεν βρέθηκε η πρόσκληση, ή έχει απενεργοποιηθεί ο σύνδεσμος"
      return
    end

    @invited_submissions = InvitedSubmission.where( invitation: @invitation ).order(id: :desc)

    render :index, layout: "invited_submission"
  end

  # GET /invited_submissions/1 or /invited_submissions/1.json
  def show
  end

  # GET /invited_submissions/new
  def new
    if not params[:secret_url_part]
      if not current_user
        redirect_to root_path, alert: "Not found!"
        return
      end
    end

    @invitation = Invitation.find_by(link: params[:secret_url_part])
    if not @invitation or not @invitation.active?
      redirect_to root_path, alert: "Δεν βρέθηκε η πρόσκληση, ή έχει απενεργοποιηθεί ο σύνδεσμος"
      return
    end

    @invited_submission = InvitedSubmission.new
    @student_submission = StudentSubmission.new
  end

  # GET /invited_submissions/1/edit
  def edit
  end

  # POST /invited_submissions or /invited_submissions.json
  def create
    if not invited_submission_params[:secret_url_part]
      redirect_to root_path, alert: "Invalid link!"
      return
    end

    @invitation = Invitation.find_by(link: invited_submission_params[:secret_url_part])
    if not @invitation or not @invitation.active?
      redirect_to root_path, alert: "Δεν βρέθηκε η πρόσκληση, ή έχει απενεργοποιηθεί ο σύνδεσμος"
    end

    @student_submission = StudentSubmission.new
    @student_submission.file.attach invited_submission_params[:submission_file]
    @student_submission.title = invited_submission_params[:submission_description]
    @student_submission.student_submission_type = StudentSubmissionType.where(
      id: invited_submission_params[:student_submission_type_id].to_i).first
    @student_submission.user   = @invitation.user
    @student_submission.student = @invitation.student

    @invited_submission = InvitedSubmission.new(invitation: @invitation, 
                                                student_submission: @student_submission)
    if not @student_submission.save
      render :new, status: :unprocessable_entity
      return
    end

    #TODO: detach submission_file from invited_submission before save
    # might not be necessary, though

    respond_to do |format|
      if @invited_submission.save
        format.html { redirect_to invited_submissions_path, notice: "Invited submission was successfully created." }
        format.turbo_stream
      else
        format.html {render :new, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /invited_submissions/1 or /invited_submissions/1.json
  def update
    respond_to do |format|
      if @invited_submission.update(invited_submission_params)
        format.html { redirect_to @invited_submission, notice: "Invited submission was successfully updated." }
        format.json { render :show, status: :ok, location: @invited_submission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invited_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invited_submissions/1 or /invited_submissions/1.json
  def destroy
    @invited_submission.destroy!

    respond_to do |format|
      format.html { redirect_to invited_submissions_path, status: :see_other, notice: "Invited submission was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def check_site_autonomous_submission
      if not @site_setting.allow_autonomous_submissions
        redirect_to root_path, alert: "Η αυτόνομη αποστολή αρχείων έχει απενεργοποιηθεί"
        return
      end

    end

    # Use callbacks to share common setup or constraints between actions.
    def set_invited_submission
      @invited_submission = InvitedSubmission.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def invited_submission_params
      params.require(:invited_submission).permit(:secret_url_part, :submission_file, 
                                                 :student_submission_type_id, :submission_description)
    end
end
