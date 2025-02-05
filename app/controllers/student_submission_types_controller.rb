class StudentSubmissionTypesController < ApplicationController
  include Pundit::Authorization

  before_action :set_student_submission_type, only: %i[ show edit update destroy ]

  # GET /student_submission_types or /student_submission_types.json
  def index
    @student_submission_types = StudentSubmissionType.all
  end

  # GET /student_submission_types/1 or /student_submission_types/1.json
  def show
  end

  # GET /student_submission_types/new
  def new
    authorize StudentSubmissionType
    @student_submission_type = StudentSubmissionType.new
  end

  # GET /student_submission_types/1/edit
  def edit
    authorize StudentSubmissionType
  end

  # POST /student_submission_types or /student_submission_types.json
  def create
    authorize StudentSubmissionType
    @student_submission_type = StudentSubmissionType.new(student_submission_type_params)

    respond_to do |format|
      if @student_submission_type.save
        format.html { redirect_to @student_submission_type, notice: "Student submission type was successfully created." }
        format.json { render :show, status: :created, location: @student_submission_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student_submission_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /student_submission_types/1 or /student_submission_types/1.json
  def update
    authorize StudentSubmissionType
    respond_to do |format|
      if @student_submission_type.update(student_submission_type_params)
        format.html { redirect_to @student_submission_type, notice: "Student submission type was successfully updated." }
        format.json { render :show, status: :ok, location: @student_submission_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student_submission_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_submission_types/1 or /student_submission_types/1.json
  def destroy
    authorize StudentSubmissionType
    @student_submission_type.destroy!

    respond_to do |format|
      format.html { redirect_to student_submission_types_path, status: :see_other, notice: "Student submission type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_submission_type
      @student_submission_type = StudentSubmissionType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_submission_type_params
      params.require(:student_submission_type).permit(:name, :description, :accepted_filetype, 
                                                      :max_submissions, :optional)
    end
end
