class TeamsController < ApplicationController
  include Pundit::Authorization

  before_action :set_team, 
    only: %i[ show secretary_show edit update destroy make_final unfinalize resend_school_approval]

  skip_before_action :authenticate_user!, only: %i[school_approval perform_school_approval]

  # GET /teams or /teams.json
  def index
    @teams = policy_scope(Team)
  end

  def admin_index
    authorize Team
    @teams = Team.includes(:school, :user, user: [:submissions]).finalized
    @not_finalized_teams = Team.includes(:school, :user).not_finalized
    @user_no_team = User.no_team
  end

  def export_xlsx
    authorize Team

    GeneratedFile.where(user: current_user, purpose: "Teams::export_xlsx").delete_all
    #TODO: Remove the files as well

    gf = GeneratedFile.new
    gf.user = current_user
    gf.purpose = "Teams::export_xlsx"
    gf.status = "PROCESSING"
    gf.filename = Rails.root.join "web_exports", gf.purpose, "#{SecureRandom.urlsafe_base64}.xlsx"

    gf.save!

    ExportSchoolsJob.perform_later( generated_file_id: gf.id )

    redirect_back_or_to root_path, notice: "Ξεκίνησε η διεργασία για την δημιουργία του αρχείου"
  end

  def download_exported_xlsx
    authorize Team

    gf = GeneratedFile.where(user: current_user, purpose: "Teams::export_xlsx").last
    if not gf
      redirect_back_or_to root_path, alert: "Δεν υπάρχει δημιουργημένο αρχείο"
      return
    end

    if gf.status == "READY"
      send_file gf.filename, type: "application/vnd.ms-excel", filename: "schools_#{gf.updated_at.strftime "%y%m%d"}.xlsx"
      return
    else
      redirect_back_or_to root_path, alert: "Το αρχείο ετοιμάζετε παρακαλώ περιμένετε"
      return
    end

  end

  # GET /teams/1 or /teams/1.json
  def show
    authorize @team
  end

  def secretary_show
    authorize @team
  end

  # GET /teams/new
  def new
    authorize Team
    @team = Team.new
    @selected_schools = School.all
  end

  # GET /teams/1/edit
  def edit
    authorize @team
  end

  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params)
    @team.user = current_user
    @selected_schools = School.all

    if @team.save
      redirect_to root_path #, notice: "Η ομάδα δημιουργήθηκε επιτυχώς"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    authorize @team

    if @team.update(team_params)
      if current_user.is_admin?
        redirect_to admin_index_teams_path, notice: "Η ομάδα ενημερώθηκε επιτυχώς"
      else
        redirect_to root_path#, notice: "Η ομάδα ενημερώθηκε επιτυχώς"
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    authorize @team
    @team.destroy!

    respond_to do |format|
      redirect_back_or_to root_path
      format.turbo_stream
    end
  end


  def make_final
    authorize @team

    if !@team.school_approval_secret or @team.school_approval_secret.empty?
      @team.update!(school_approval_secret: SecureRandom.urlsafe_base64)
    end

    if !@team.school or
        !@team.school.contact_email or
        @team.school.contact_email.empty? or
        @team.school.contact_email.count("@") != 1 or
        @team.school.contact_email.strip.count(" ") != 0 or
        @team.school.contact_email.count(".") == 0 

      redirect_back_or_to root_path, 
        alert: "Πρόβλημα με το επίσημο email της σχολικής μονάδας. Παρακαλώ επικοινωνήστε με την υποστήριξη"

      return
    end

    @team.update(finalized: true, finalized_date: DateTime.now)

    # Για το email που απαιτεί την επιβεβαίωση του σχολείου,
    # επειδή μερικοί διευθυντές θα χρησιμοποιήσουν το επίσημο email 
    # του σχολείου, 
    # σε αυτή την περίπτωση θεώρησε ως approved απευθείας το email.
    #
    if current_user.email == @team.school.contact_email.strip
      # o τρέχων χρήστης έχει ήδη κάνει επιβεβαίωση του λογαριασμού του
      # και ο λογαριασμός του είναι αυτός της σχολικής μονάδας.
      # Δεν χρειάζεται να σταλεί το email για school approval,
      # μπορούμε απευθείας να το θεωρήσουμε approoved

      perform_school_approval_internal

    else
      send_school_approval
    end



    redirect_back_or_to root_path, notice: "Η ομάδα οριστικοποιήθηκε επιτυχώς"
  end

  def unfinalize
    authorize @team
    @team.update!(finalized: false, 
                  finalized_date: DateTime.now,
                  school_approved: false,
                  school_approval_secret: nil)

    redirect_back_or_to root_path, notice: "Αφαιρέθηκε η οριστικοποίηση της ομάδας επιτυχώς."
  end

  def school_approval
    if not params[:secret_url_part]
      redirect_to root_path, alert: "Invalid link!"
      return
    end

    @team = Team.find_by(school_approval_secret: params[:secret_url_part])
    if not @team 
      redirect_to root_path, alert: "Πρόβλημα με το σύνδεσμο"
      return
    end

    if @team.school_approved?
      redirect_to root_path, notice: "Έχει γίνει επιτυχώς η επιβεβαίωση"
      return
    end


    render :school_approval, layout: "school_approval"
  end

  def resend_school_approval
    authorize @team

    send_school_approval

    redirect_back_or_to root_path, 
      notice: "Έγινε η αποστολή το email προς #{@team.school.contact_email}"
  end

  def perform_school_approval
    if not params[:secret_url_part]
      redirect_to root_path, alert: "Invalid link!"
      return
    end

    @team = Team.find_by(school_approval_secret: params[:secret_url_part])
    if not @team 
      redirect_to root_path, alert: "Πρόβλημα με το σύνδεσμο"
      return
    end

    if @team.school_approved?
      redirect_to root_path, notice: "Έχει γίνει επιτυχώς η επιβεβαίωση"
      return
    end

    perform_school_approval_internal

    redirect_to root_path, notice: "Έγινε επιτυχώς η επιβεβαίωση"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
      @selected_schools = School.all #TODO: Επιλογή σχολείων βάση περιφέρειας
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:nickname, :school_id, :contact_phone, :contact_email)#, :user_id)
    end

    def send_school_approval
      UserMailer.with(team: @team).school_request_confirmation.deliver_later

      sent_email = SentEmail.new
      sent_email.user = current_user
      sent_email.person = nil
      sent_email.recipient_email = @team.school.contact_email #ΜΟΝΟ στο επίσημο!
      sent_email.description = "request_school_confirmation"
      sent_email.save!
    end

    def perform_school_approval_internal
      @team.update_attribute(:school_approved, true)

      UserMailer.with(team: @team).school_confirmed.deliver_later
      sent_email = SentEmail.new
      sent_email.user = @team.user
      sent_email.person = nil
      sent_email.recipient_email = @team.user.teachers.map{ |t| t.person.contact_email }.compact.join(";")
      sent_email.recipient_email = @team.user.email + ";" + sent_email.recipient_email
      sent_email.description = "confirmation_of_approved_school"
      sent_email.save!

    end
end
