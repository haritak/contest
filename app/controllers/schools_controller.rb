class SchoolsController < ApplicationController
  include Pundit::Authorization

  before_action :set_school, only: %i[ show edit update destroy]

  # GET /schools or /schools.json
  def index
    if params[:search_keys]
      keywords = params[:search_keys].split
      keywords = keywords.map { |k| School.sanitize_sql_like k }
      keywords = "%" + keywords.join("%") + "%"
      @schools = School.where("name LIKE ?", keywords)
    else
      @schools = School.all
    end
  end

  # GET /schools/1 or /schools/1.json
  def show
  end

  # GET /schools/new
  def new
    @school = School.new
  end

  # GET /schools/1/edit
  def edit
    authorize @school
  end

  # POST /schools or /schools.json
  def create
    @school = School.new(school_params)
    @school.user = current_user

    if @school.save
      redirect_to root_path, notice: "Επιτυχής δημιουργία σχολείου"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /schools/1 or /schools/1.json
  def update
    authorize @school

    if @school.update(school_params)
      redirect_to root_path, notice: "Επιτυχής ενημέρωση στοιχείων σχολείου"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /schools/1 or /schools/1.json
  def destroy
    @school.destroy!

    redirect_to root_path, status: :see_other, notice: "Επιτυχής διαγραφή σχολείου"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school
      @school = School.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def school_params
      params.require(:school).permit(:name, :school_type_id, :education_directorate_id, :city, :contact_phone, :contact_email, :is_spedu)#, :user_id)
    end
end
