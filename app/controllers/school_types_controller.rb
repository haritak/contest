class SchoolTypesController < ApplicationController
  include Pundit::Authorization

  before_action :set_school_type, only: %i[ show edit update destroy ]

  # GET /school_types or /school_types.json
  def index
    @school_types = SchoolType.all
  end

  # GET /school_types/1 or /school_types/1.json
  def show
  end

  # GET /school_types/new
  def new
    authorize SchoolType
    @school_type = SchoolType.new
  end

  # GET /school_types/1/edit
  def edit
    authorize SchoolType
  end

  # POST /school_types or /school_types.json
  def create
    authorize SchoolType
    @school_type = SchoolType.new(school_type_params)

    respond_to do |format|
      if @school_type.save
        format.html { redirect_to @school_type, notice: "School type was successfully created." }
        format.json { render :show, status: :created, location: @school_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @school_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /school_types/1 or /school_types/1.json
  def update
    authorize SchoolType
    respond_to do |format|
      if @school_type.update(school_type_params)
        format.html { redirect_to @school_type, notice: "School type was successfully updated." }
        format.json { render :show, status: :ok, location: @school_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @school_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /school_types/1 or /school_types/1.json
  def destroy
    authorize SchoolType
    @school_type.destroy!

    respond_to do |format|
      format.html { redirect_to school_types_path, status: :see_other, notice: "School type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school_type
      @school_type = SchoolType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def school_type_params
      params.require(:school_type).permit(:school_type)
    end
end
