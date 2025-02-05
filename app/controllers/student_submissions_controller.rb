class StudentSubmissionsController < ApplicationController
  include Pundit::Authorization

  before_action :set_student_submission, only: %i[ show edit update destroy 
  make_final unfinalize
  toggle_mark_ok toggle_review_public review_edit review_set_note]

  # GET /student_submissions or /student_submissions.json
  def index
    @student_submissions = policy_scope(StudentSubmission).order(user_id: :asc, student_submission_type_id: :asc)
  end

  def admin_index
    authorize StudentSubmission

    @student_submission_types = StudentSubmissionType.order(optional: :asc, id: :asc).all

    @students = Student.joins(:user).
      includes(:team, :school, :school_type, :student_submissions, :student_submission_types, 
               {student_submissions: [file_attachment: :blob]}, 
               {student_submissions: :student_submission_type} ).
      order(user_id: :asc, school_class_id: :asc)

    @total_kids = @students.kids.count
    @total_adults = @students.adults.count
    @total_kids_and_adults = @students.count

    @pagy, @students = pagy(@students)
  end

  # GET /student_submissions/1 or /student_submissions/1.json
  def show
    authorize @student_submission
  end

  # GET /student_submissions/new
  def new
    authorize StudentSubmission
    @student_submission = StudentSubmission.new
  end

  # GET /student_submissions/1/edit
  def edit
    authorize @student_submission
  end

  def make_final
    authorize @student_submission
    @student_submission.update(finalized: true, finalized_date: DateTime.now)

    if current_user.is_admin? or current_user.is_secretary?
      render partial: "finalize_state", locals: {student_submission: @student_submission}
    else
      render @student_submission
    end
  end

  def unfinalize
    authorize @student_submission
    @student_submission.update(finalized: false, finalized_date: DateTime.now)

    render partial: "finalize_state", locals: {student_submission: @student_submission}
  end

  def toggle_mark_ok
    authorize @student_submission
    @student_submission.toggle!(:review_marked_ok)

    render partial: "student_submissions/review_block", locals: {student_submission: @student_submission, edit_mode: false}
  end

  def toggle_review_public
    authorize @student_submission
    @student_submission.toggle!(:review_public)

    if @student_submission.review_public?
      @student_submission.student.increment!(:reviews_counter)
    else
      @student_submission.student.decrement!(:reviews_counter)
    end

    render partial: "student_submissions/review_block", locals: {student_submission: @student_submission, edit_mode: false}
  end

  def review_edit
    authorize @student_submission

    render partial: "student_submissions/review_block", locals: {student_submission: @student_submission, edit_mode: true}
  end

  def review_set_note
    authorize @student_submission
    if params[:student_submission]
      if params[:student_submission][:review_notes]
        @student_submission.update_attribute(:review_notes, params[:student_submission][:review_notes])
      end
    end

    render partial: "student_submissions/review_block", locals: {student_submission: @student_submission, edit_mode: false}
  end

  # POST /student_submissions or /student_submissions.json
  def create
    authorize StudentSubmission
    @student_submission = StudentSubmission.new(student_submission_params)
    @student = @student_submission.student
    @student_submission.user = current_user

    respond_to do |format|
      if @student_submission.save
        format.html { redirect_to @student_submission, notice: "Student submission was successfully created." }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /student_submissions/1 or /student_submissions/1.json
  def update
    authorize @student_submission
    respond_to do |format|
      if @student_submission.update(student_submission_params)
        format.html { redirect_to @student_submission, notice: "Student submission was successfully updated." }
        format.json { render :show, status: :ok, location: @student_submission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_submissions/1 or /student_submissions/1.json
  def destroy
    authorize @student_submission

    invited_subs = InvitedSubmission.where(student_submission: @student_submission)
    if invited_subs.first != nil
      invited_subs.delete_all
    end
    @student_submission.file.purge
    @student_submission.destroy!

    respond_to do |format|
      format.html { redirect_to student_submissions_path, status: :see_other, notice: "Student submission was successfully destroyed." }
      format.turbo_stream
    end
  end

  def export_xlsx
    authorize Team

    GeneratedFile.where(user: current_user, purpose: "StudentSubmissions::export_xlsx").delete_all
    #TODO: Remove the files as well

    gf = GeneratedFile.new
    gf.user = current_user
    gf.purpose = "StudentSubmissions::export_xlsx"
    gf.status = "PROCESSING"
    gf.filename = Rails.root.join "web_exports", gf.purpose, "#{SecureRandom.urlsafe_base64}.xlsx"

    gf.save!

    ExportStudentSubmissionsJob.perform_later( generated_file_id: gf.id )

    redirect_back_or_to root_path, notice: "Ξεκίνησε η διεργασία για την δημιουργία του αρχείου"
  end

  def download_exported_xlsx
    authorize StudentSubmission

    gf = GeneratedFile.where(user: current_user, purpose: "StudentSubmissions::export_xlsx").last
    if not gf
      redirect_back_or_to root_path, alert: "Δεν υπάρχει δημιουργημένο αρχείο"
      return
    end

    if gf.status == "READY"
      send_file gf.filename, type: "application/vnd.ms-excel", filename: "student_submissions_#{gf.updated_at.strftime "%y%m%d"}.xlsx"
      return
    else
      redirect_back_or_to root_path, alert: "Το αρχείο ετοιμάζετε παρακαλώ περιμένετε"
      return
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_submission
      @student_submission = StudentSubmission.find(params[:id])
      @student = @student_submission.student
    end

    # Only allow a list of trusted parameters through.
    def student_submission_params
      params.require(:student_submission).permit(:student_id, :student_submission_type_id, :file, 
                                                 :title, :notes)#, :user_id, :finalized, :finalized_date)
    end
end
