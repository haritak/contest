class TeachersController < ApplicationController
  include Pundit::Authorization

  before_action :set_teacher, only: %i[ show edit update destroy make_final unfinalize toggle_coadmin]

  # GET /teachers or /teachers.json
  def index
    @teachers = policy_scope(Teacher)
  end

  def admin_index
    authorize Teacher

    @teachers = Teacher.finalized.joins(:person).
      includes(:person, :user, :team, :school).
      order("people.user_id": :asc, "people.last_name": :asc, "people.first_name": :asc).all
  end

  # GET /teachers/1 or /teachers/1.json
  def show
    authorize @teacher
  end

  # GET /teachers/new
  def new
    authorize Teacher
    @person = Person.new
    @teacher = Teacher.new
  end

  # GET /teachers/1/edit
  def edit
    authorize @teacher
  end

  def make_final
    authorize @teacher
    @teacher.update(finalized: true, finalized_date: DateTime.now)

    redirect_back_or_to root_path, notice: "Ο/η εκπαιδευτικός #{@teacher.person.short_name} οριστικοποιήθηκε επιτυχώς"
  end

  def toggle_coadmin
    authorize @teacher

    @teacher.toggle!(:coadmin)

    redirect_back_or_to root_path, 
      notice: "Ο/η εκπαιδευτικός #{@teacher.person.short_name} " +
      (@teacher.coadmin? ? " έγινε " : "αφαιρέθηκε από ") +
      " συνδιαχεριστής/στρια επιτυχώς"
  end

  def unfinalize
    authorize @teacher
    @teacher.update(finalized: false, finalized_date: DateTime.now)

    redirect_back_or_to root_path, notice: "Αφαιρέθηκε η οριστικοποίηση του/της εκπαιδευτικού  '#{@teacher.person.short_name}' επιτυχώς."
  end

  # POST /teachers or /teachers.json
  def create
    authorize Teacher
    @person = Person.new(person_params)
    @person.user = current_user
    @teacher = Teacher.new(teacher_params)

    if not @person.save
      render :new, status: :unprocessable_entity
      return
    end

    @teacher.person = @person

    if @teacher.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Επιτυχής δημιουργία εκπαιδευτικού" }
        format.turbo_stream
      end
    else
      @person.destroy
      render :new, status: :unprocessable_entity 
    end

  end

  # PATCH/PUT /teachers/1 or /teachers/1.json
  def update
    authorize @teacher
    if not @person.update(person_params)
      render :edit, status: :unprocessable_entity
      return
    end

    if @teacher.update(teacher_params)
      if current_user.is_admin?
        redirect_to admin_index_teachers_path, notice: "Επιτυχής ενημέρωση εκπαιδευτικού"
      else
        redirect_to root_path
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /teachers/1 or /teachers/1.json
  def destroy
    authorize @teacher.person
    @person = @teacher.person

    if @teacher.finalized?
      redirect_to admin_index_teachers_path, alert: "Πρέπει να αφαιρεθεί η οριστικοποίηση πρώτα"
      return
    end

    @teacher.transaction do 
      @teacher.destroy!
      @person.destroy!
    end

    if current_user.is_admin?
      redirect_to admin_index_teachers_path, notice: "Teacher was successfully destroyed."
    else
      respond_to do |format|
        format.html { redirect_to root_path, status: :see_other, notice: "Ο/η εκπαιδευτικός διαγράφηκε"}
        format.turbo_stream
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find(params[:id])
      @person = @teacher.person
    end

    # Only allow a list of trusted parameters through.
    def teacher_params
      params.require(:teacher).permit(:person_id, :speciality_id, :team_role, :gdpr_accepted)
    end

    def person_params
      PeopleController.person_params(params)
      #params.require(:person).permit(:last_name, :first_name, :father_name, :mother_name, :gender, :contact_phone, :contact_email)
    end
end
