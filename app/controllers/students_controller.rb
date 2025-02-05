class StudentsController < ApplicationController
  include Pundit::Authorization

  before_action :set_student, only: %i[ show edit update destroy 
  prepare_invitation_link deactivate_invitation_link activate_invitation_link
  submit_invitation_link new_submission new_typed_submission my_submissions
  make_final unfinalize ]

  # GET /students or /students.json
  def index
    @students = policy_scope(Student).includes(:person).order(user_id: :asc, school_class_id: :asc, last_name: :asc, first_name: :asc)
  end

  def admin_index
    authorize Student

    @students = policy_scope(Student).includes(:person, :user, :team, :school, :school_class).
      order("users.id, school_class_id, is_adult, people.last_name, people.first_name")
  end


  # GET /students/1 or /students/1.json
  def show
    authorize @student.person
  end

  # GET /students/new
  def new
    authorize Student
    @person = Person.new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
    authorize @student.person
  end

  def make_final
    authorize @student
    @student.update(finalized: true)

    redirect_back_or_to root_path, notice: "Ο/η  #{@student.person.short_name} οριστικοποιήθηκε επιτυχώς"
  end

  def unfinalize
    authorize @teacher
    @teacher.update(finalized: false)

    redirect_back_or_to root_path, notice: "Αφαιρέθηκε η οριστικοποίηση '#{@student.person.short_name}' επιτυχώς."
  end

  def prepare_invitation_link
    authorize @student.person
    @invitation = Invitation.where(user: current_user, student:@student).first
    if @invitation == nil 
      @invitation = prepare_invitation_link_internal
    end
    render partial: "invitations/form", locals:{  invitation: @invitation }
    return
  end

  def activate_invitation_link
    authorize @student.person
    @student.invitation.update( active: true )

    render @student
    return
  end

  def deactivate_invitation_link
    authorize @student.person
    @student.invitation.update( active: false )

    render @student
    return
  end

  def submit_invitation_link
    UserMailer.with(invitation: @student.invitation).student_invitation.deliver_later
    sent_email = SentEmail.new
    sent_email.user = current_user
    sent_email.person = @student.person
    sent_email.recipient_email = @student.person.contact_email
    sent_email.description = "submit_invitation_link"
    sent_email.save!
    render @student
    return
  end

  def new_submission
    authorize @student.person

    @student_submission = StudentSubmission.new
    @student_submission.student = @student
    @student_submission.user = @student.user
  end

  def new_typed_submission
    authorize @student.person

    
    @student_submission = StudentSubmission.new
    @student_submission.student = @student
    @student_submission.user = current_user
    @student_submission.student_submission_type = StudentSubmissionType.find(params[:student_submission_type])

    render 'new_submission'
  end

  def my_submissions
    authorize @student.person

    render partial: "student_submissions/student_submissions", locals: {student: @student}
  end

  # POST /students or /students.json
  def create
    authorize Student
    @person = Person.new(person_params)
    @person.user = current_user
    @student = Student.new(student_params)

    if not @person.save
      render :new, status: :unprocessable_entity
      return
    end

    @student.person = @person

    if @student.save
      @invitation = prepare_invitation_link_internal
      @invitation.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Επιτυχής δημιουργία μαθητή/μαθήτριας" }
        format.turbo_stream
      end
    else
      @person.destroy
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    authorize @student.person
    if not @person.update(person_params)
      render :edit, status: :unprocessable_entity
      return
    end

    if @student.update(student_params)
      redirect_to root_path, notice: "Επιτυχής ενημέρωση στοιχείων μαθητή/μαθήτριας"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    authorize @student.person
    @person = @student.person

    @student.transaction do
      SentEmail.where(person: @person).update_all(person_id: nil)
      Invitation.where(student: @student).each do |inv|
        InvitedSubmission.where( invitation: inv).delete_all
      end
      Invitation.where(student: @student).delete_all
      StudentSubmission.where(student: @student).each do |ss|
        ss.file.purge_later
      end
      StudentSubmission.where(student: @student).delete_all
      @student.destroy!
      @person.destroy!
    end

    respond_to do |format|
      format.html { redirect_to root_path, status: :see_other, notice: "Επιτυχής διαγραφή μαθητή/μαθήτριας" }
      format.turbo_stream
    end
  end

  private

    def prepare_invitation_link_internal
      @invitation = Invitation.new
      @invitation.user = current_user
      @invitation.student = @student
      @invitation.link = SecureRandom.urlsafe_base64
      @invitation.active = true

      return @invitation
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
      @person = @student.person
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:person_id, :school_class_id, :is_adult, :guardian)
    end

    def person_params
      PeopleController.person_params(params)
    end
end
