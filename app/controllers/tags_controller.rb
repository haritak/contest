class TagsController < ApplicationController
  include Pundit::Authorization

  before_action :set_tag, only: %i[ show edit update destroy set_active]
  before_action :set_tags_to_show, only: %i[ apply_active_tag delete_selected_tag apply_specific_tag ]

  def get_active_tags
    ssid = params[:id] # Watch it : its a student_submission_id!!!
    return if not ssid
    return if not current_user

    @student_submission = StudentSubmission.includes(:student_submission_user_tags, :tags).find(ssid)
    @tags_to_show = Tag.of_user_or_global(current_user)

    render partial: "tags/student_submission_tags", locals: {student_submission: @student_submission, tags_to_show: @tags_to_show}
  end

  def set_active
    session[:current_tag_id] = @tag.id

    render partial: "tags_menu"
  end

  def apply_active_tag
    return if not session[:current_tag_id]
    return if not params[:id] # Watch it : its a student_submission_id!!!
    return if not current_user


    ssid = params[:id]
    ss = StudentSubmission.find(ssid)
    ssut = StudentSubmissionUserTag.new
    ssut.user = current_user
    ssut.student_submission_id = ssid
    ssut.tag_id = session[:current_tag_id]

    return if StudentSubmissionUserTag.where(user: current_user,
                                             student_submission_id: ssid,
                                             tag_id: session[:current_tag_id]).count > 0

    ssut.save!


    render partial: "tags/student_submission_tags", locals: {student_submission: ss, tags_to_show: @tags_to_show}
  end

  def delete_selected_tag
    return if not params[:ssu_tag_id]
    return if not params[:id] # Watch it : its a student_submission_id!!!
    return if not current_user

    ssid = params[:id]
    ss = StudentSubmission.find(ssid)
    ssutag = StudentSubmissionUserTag.find(params[:ssu_tag_id])

    ssutag.destroy

    render partial: "tags/student_submission_tags", locals: {student_submission: ss, tags_to_show: @tags_to_show}
  end

  def apply_specific_tag
    return if not params[:specific_tag_id]
    return if not params[:id] # Watch it : its a student_submission_id!!!
    return if not current_user

    ssid = params[:id]
    ss = StudentSubmission.find(ssid)
    tag = Tag.find(params[:specific_tag_id])

    return if StudentSubmissionUserTag.where(user: current_user, student_submission: ss, tag: tag).count > 0

    ssut = StudentSubmissionUserTag.new
    ssut.user = current_user
    ssut.student_submission_id = ssid
    ssut.tag_id = params[:specific_tag_id]

    ssut.save!

    render partial: "tags/student_submission_tags", locals: {student_submission: ss, tags_to_show: @tags_to_show}
  end


  # GET /tags or /tags.json
  def index
    @tags = Tag.all
  end

  # GET /tags/1 or /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags or /tags.json
  def create
    @tag = Tag.new(tag_params)
    @tag.user = current_user

    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, notice: "Tag was successfully created." }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tags/1 or /tags/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag, notice: "Tag was successfully updated." }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1 or /tags/1.json
  def destroy
    @tag.destroy!

    respond_to do |format|
      format.html { redirect_to tags_path, status: :see_other, notice: "Tag was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    def set_tags_to_show
      @tags_to_show = Tag.of_user_or_global(current_user)
    end

    # Only allow a list of trusted parameters through.
    def tag_params
      if current_user&.is_admin? 
        params.require(:tag).permit(:name, :description, :color, :is_global)
      else
        params.require(:tag).permit(:name, :description, :color)
      end
    end
end
