class UsersController < ApplicationController
  include Pundit::Authorization

  before_action :set_user, only: %i[ show edit update destroy 
  make_participation_final unfinalize_participation
  make_participation_to_seminar_final unfinalize_participation_to_seminar 
  become manualy_confirm]

  # GET /users or /users.json
  def index
    @users = policy_scope(User)
  end

  # GET /users/1 or /users/1.json
  def show
    authorize @user
  end

  # GET /users/new
  def new
    authorize User
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    authorize @user
  end

  # POST /users or /users.json
  def create
    authorize User

    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    authorize @user
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def make_participation_final
    authorize @user

    message = common_finalize_checks
    if message
      redirect_to root_path, alert: message
      return
    end

    if @user.students.count < 1
      redirect_to root_path, alert: 
        "Υπάρχουν ακόμα εκκρεμότητες! Παρακαλούμε προσθέστε τουλάχιστον έναν/μία μαθητή/μαθήτρια"
      return
    end

    no_mandatory_files = StudentSubmissionType.mandatory.count
    @user.students.each do |student|

      if student.student_submissions.mandatory.count < no_mandatory_files
        redirect_to root_path, alert: 
          "Υπάρχουν ακόμα εκκρεμότητες! Λείπουν αρχεία #{student.person.tou_mathiti} με όνομα: #{student.person.short_name}"
        return
      end

      if student.student_submissions.optional.count == 0
        redirect_to root_path, alert: 
          "Υπάρχουν ακόμα εκκρεμότητες: #{student.person.o_mathitis} με όνομα: #{student.person.short_name}, δεν έχει φωτογραφίες!"
        return
      end

      if student.student_submissions.any? { |ss| not ss.finalized? }
        redirect_to root_path, alert: 
          "Υπάρχουν ακόμα εκκρεμότητες: Μη οριστικοποιημένα αρχεία/φωτογραφίες για #{student.person.ton_mathiti} με όνομα: #{student.person.short_name}"
        return
      end


    end

    send_receipt_of_participation

    @user.team.update(participation_finalized: true, participation_finalized_date: DateTime.now)

    redirect_to root_path, notice: "Η συμμετοχή σας έχει υποβληθεί"
  end

  def unfinalize_participation
    authorize @user
    @user.team.update(participation_finalized: false, participation_finalized_date: DateTime.now)

    redirect_to root_path, notice: "Η οριστικοποίηση της συμμετοχής αφαιρέθηκε"
  end

  def make_participation_to_seminar_final
    authorize @user
    message = common_finalize_checks
    if message
      redirect_to root_path, alert: message
      return
    end

    SubmissionType.optional.each do |st|
      if @user.submissions.where( submission_type: st).count == 0
        redirect_to root_path, alert: "Υπάρχουν ακόμα εκκρεμότητες! Παρακαλούμε προσθέστε το αρχείο #{st.submission_type}"
        return 
      end

      @user.submissions.where( submission_type: st).each do |sm|
        if not sm.finalized?
          redirect_to root_path, alert: "Υπάρχουν ακόμα εκκρεμότητες! Παρακαλούμε οριστικοποιήστε το αρχείο #{st.submission_type}"
          return 
        end
      end
    end

    send_receipt_of_seminar_participation

    @user.team.update(seminar_participation_finalized: true, seminar_participation_finalized_date: DateTime.now)

    redirect_back_or_to root_path, notice: "Η υποβολή αίτησης συμμετοχής στο σεμινάριο φωτογραφίας έχει υποβληθεί"
  end

  def unfinalize_participation_to_seminar
    authorize @user

    @user.team.update(seminar_participation_finalized: false, seminar_participation_finalized_date: DateTime.now)

    redirect_back_or_to root_path, notice: "Έχει αναιρεθεί η οριστικοποίηση συμμετοχής στο σεμινάριο φωτογραφίας"
  end

  def become
    authorize @user

    sign_in( @user )
    redirect_to root_path, notice: "Μεταμορφωθήκατε σε #{@user.email}!"
  end

  def manualy_confirm
    authorize @user

    @user.confirm
    @user.save
    redirect_to root_path, notice: "Έγινε η επαλήθευση (confirmation) για το #{@user.email}!"
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def common_finalize_checks
      return "Υπάρχουν ακόμα εκκρεμότητες! Παρακαλούμε συμπληρώστε τα στοιχεία του σχολείου" if not @user.team 
      return "Υπάρχουν ακόμα εκκρεμότητες! Παρακαλούμε οριστικοποιήστε τα στοιχεία του σχολείου" if not @user.team.finalized?
      return "Υπάρχουν ακόμα εκκρεμότητες! Παρακαλούμε προσθέστε τουλάχιστον έναν εκπαιδευτικό" if @user.teachers.count == 0
      return "Υπάρχουν ακόμα εκκρεμότητες! Παρακαλούμε οριστικοποιήστε τα στοιχεία τουλάχιστον ενός/μίας εκπαιδευτικού" if not @user.teachers.any? { |teacher| teacher.finalized? }

      SubmissionType.mandatory.each do |st|
        if @user.submissions.where( submission_type: st).count == 0
          return "Υπάρχουν ακόμα εκκρεμότητες! Παρακαλούμε προσθέστε το αρχείο #{st.submission_type}"
        end

        @user.submissions.where( submission_type: st).each do |sm|
          if not sm.finalized?
            return "Υπάρχουν ακόμα εκκρεμότητες! Παρακαλούμε οριστικοποιήστε το αρχείο #{st.submission_type}"
          end
        end
      end

      return "Υπάρχουν ακόμα εκκρεμότητες! Παρακαλούμε προσθέστε τουλάχιστον έναν εκπαιδευτικό" if @user.teachers.count == 0
      return "Υπάρχουν ακόμα εκκρεμότητες! Παρακαλούμε προσθέστε τα απαιτούμενα αρχεία" if @user.submissions.mandatory.count < SubmissionType.mandatory.count

      #χωρίς εκκρεμότητες

      return nil #no errors
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :username)
    end

    def send_receipt_of_participation
      @team = @user.team
      UserMailer.with(team: @team).send_receipt_of_participation.deliver_later

      sent_email = SentEmail.new
      sent_email.user = current_user
      sent_email.person = nil
      other_emails = [@team.user.email, @team.school.contact_email]
      @team.user.teachers.finalized.each do |t| 
        if t.person.contact_email and !t.person.contact_email.empty?
          other_emails << t.person.contact_email
        end
      end
      other_emails = other_emails.join(";")
      sent_email.recipient_email = @team.school.contact_email
      sent_email.description = "participation_receipt"
      sent_email.save!
    end

    def send_receipt_of_seminar_participation
      @team = @user.team
      UserMailer.with(team: @team).send_receipt_of_seminar_participation.deliver_later

      sent_email = SentEmail.new
      sent_email.user = current_user
      sent_email.person = nil
      other_emails = [@team.user.email, @team.school.contact_email]
      @team.user.teachers.finalized.each do |t| #Μην βάλεις τους finalized, γιατί μπορεί να μην έχουν κάνει ακόμα τον εαυτό τους finalized!
        if t.person.contact_email and !t.person.contact_email.empty?
          other_emails << t.person.contact_email
        end
      end
      other_emails = other_emails.join(";")
      sent_email.recipient_email = @team.school.contact_email
      sent_email.description = "seminar_participation_receipt"
      sent_email.save!
    end
end
