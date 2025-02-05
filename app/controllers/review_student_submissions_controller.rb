class ReviewStudentSubmissionsController < ApplicationController
  include Pundit::Authorization

  def index
    @tags_to_show = Tag.of_user_or_global(current_user)

    @thumb_size = session[:thumb_size].presence || 50 
    @thumb_size = @thumb_size.to_i

    @title = ""

    @student_category = params[:student_category]
    @student_submission_type = StudentSubmissionType.find(params[:student_submission_type_id])

    @student_submissions = case @student_category
    when "adult"
      @title = "Ενήλικες"
      StudentSubmission.adult
    when "gymnasium"
      @title = "Γυμνάσια"
      StudentSubmission.kid.gymnasium
    when "lyceum"
      @title = "Λύκεια"
      StudentSubmission.kid.lyceum
    when "all"
      @title = "Όλες"
      StudentSubmission.optional
    when "spedu"
      @title = "Ειδικών Σχολείων"
      StudentSubmission.spedu
    when "girls"
      @title = "Κοριτσιών"
      StudentSubmission.girls
    when "boys"
      @title = "Αγοριών"
      StudentSubmission.boys
    else
      throw Exception.new "Unknown student_category"
    end

    if current_user.is_reviewer?
      @student_submissions = @student_submissions.finalized
    end

    @active_tags = []
    if params["tags"].present?
      params["tags"].keys.each_with_index do |key, index|
        if params["tags"][key] == "1"
          @active_tags << key
        end
      end
    end

    if not @active_tags.empty?
      @student_submissions = @student_submissions.joins(:student_submission_user_tags)
      if current_user.is_admin?
        #ο admin βλέπει τις επιλογές όλων
        @student_submissions = @student_submissions.where(tags: {name: @active_tags})
      else
        @student_submissions = @student_submissions.where(student_submission_user_tags: {user_id: current_user, tags: {name: @active_tags}})
      end
    else
      @student_submissions = @student_submissions.left_outer_joins(:student_submission_user_tags)
    end

    @student_submissions = @student_submissions.
      includes( student_submission_user_tags: :tag).
      includes( student_submission_user_tags: :user).
      includes( :student, :user, :student_submission_type).
      includes( :student_submission_user_tags).
      includes( :team).
      includes( file_attachment: :blob)

    if @student_category != "all"
      @title += " - #{@student_submission_type.name}"
      @student_submissions = @student_submissions.
        where( student_submission_type_id: @student_submission_type.id)
    end



    # Για κάποιο λόγο spedu, girls και boys scopes δίνουν όσες εγγραφες όσα είναι και τα tags.
    @student_submissions = @student_submissions.distinct
    @title += " (#{@student_submissions.count})"
    @student_submission_ids = @student_submissions.map(&:id)

    @pagy, @student_submissions = pagy(@student_submissions)
  end

  def show
  end

  def next
  end

  def previous
  end

  def tag_student_submission
  end

end
