class EducationDirectoratesController < ApplicationController
  before_action :set_education_directorate, only: %i[ show edit update destroy ]

  # GET /education_directorates or /education_directorates.json
  def index
    @education_directorates = EducationDirectorate.all
  end

  # GET /education_directorates/1 or /education_directorates/1.json
  def show
  end

  # GET /education_directorates/new
  def new
    @education_directorate = EducationDirectorate.new
  end

  # GET /education_directorates/1/edit
  def edit
  end

  # POST /education_directorates or /education_directorates.json
  def create
    @education_directorate = EducationDirectorate.new(education_directorate_params)

    respond_to do |format|
      if @education_directorate.save
        format.html { redirect_to @education_directorate, notice: "Education directorate was successfully created." }
        format.json { render :show, status: :created, location: @education_directorate }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @education_directorate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /education_directorates/1 or /education_directorates/1.json
  def update
    respond_to do |format|
      if @education_directorate.update(education_directorate_params)
        format.html { redirect_to @education_directorate, notice: "Education directorate was successfully updated." }
        format.json { render :show, status: :ok, location: @education_directorate }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @education_directorate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /education_directorates/1 or /education_directorates/1.json
  def destroy
    @education_directorate.destroy!

    respond_to do |format|
      format.html { redirect_to education_directorates_path, status: :see_other, notice: "Education directorate was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_education_directorate
      @education_directorate = EducationDirectorate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def education_directorate_params
      params.require(:education_directorate).permit(:name)
    end
end
