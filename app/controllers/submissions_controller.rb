class SubmissionsController < ApplicationController
  include Pundit::Authorization

  before_action :set_submission, only: %i[ show edit update destroy 
  make_final unfinalize toggle_reviewed save_review_notes]

  # GET /submissions or /submissions.json
  def index
    @submissions = policy_scope(Submission).order(user_id: :asc, submission_type_id: :asc)
  end

  def admin_index
    authorize Submission

    @submissions = policy_scope(Submission).
      includes( :user, :submission_type).includes( submission_file_attachment: :blob).
      includes( {user:[:team, :teachers]}, {team:[:school]}, {teachers:[:person]} ).
    order(user_id: :asc, submission_type_id: :asc)
  end

  # GET /submissions/1 or /submissions/1.json
  def show
    authorize @submission
  end

  # GET /submissions/new
  def new
    authorize Submission
    @submission = Submission.new
  end

  # GET /submissions/1/edit
  def edit
    authorize @submission
  end

  def make_final
    authorize @submission
    @submission.update_attribute(:finalized, true)
    @submission.update_attribute(:finalized_date, DateTime.now)

    redirect_back_or_to root_path, notice: "Το αρχείο οριστικοποιήθηκε επιτυχώς"
  end

  def unfinalize
    authorize @submission
    @submission.update_attribute(:finalized, false)
    @submission.update_attribute(:finalized_date, DateTime.now)

    redirect_back_or_to root_path, notice: "Αφαιρέθηκε η οριστικοποίηση του αρχείου επιτυχώς."
  end

  def toggle_reviewed
    authorize @submission
    @submission.toggle!(:reviewed)

    render partial: "toggle_admin_index", locals: {submission: @submission }
  end

  def save_review_notes
    authorize @submission

    if notes = params[:submission][:reviewer_notes]
      @submission.update_attribute(:reviewer_notes, notes)
    end

    render partial: "reviewer_notes", locals: {submission: @submission }
  end

  # POST /submissions or /submissions.json
  def create
    authorize Submission
    @submission = Submission.new(submission_params)
    @submission.user = current_user

    if @submission.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Επιτυχής υποβολή αρχείου" }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /submissions/1 or /submissions/1.json
  def update
    authorize @submission
    if @submission.update(submission_params)
      #redirect_to @submission, notice: "Submission was successfully updated."
      redirect_to root_path, notice: "Επιτυχής ενημέρωση αρχείου"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /submissions/1 or /submissions/1.json
  def destroy
    authorize @submission

    invited_subs = InvitedSubmission.where(submission: @submission)
    if invited_subs.first != nil
      invited_subs.delete_all
    end
    @submission.submission_file.purge_later
    @submission.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Το αρχείο διαγράφηκε επιτυχώς" }
      format.turbo_stream
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = Submission.find(params[:id])
      @submitters = current_user.people
    end

    # Only allow a list of trusted parameters through.
    def submission_params
      params.require(:submission).permit(:submission_file, :submission_description, 
                                         :submission_type_id)# TODO: completely remove person id from database, :person_id) #, :user_id) 
    end
end
