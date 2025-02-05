class WelcomeController < ApplicationController
  include Pundit::Authorization

  skip_before_action :authenticate_user!

  def index
    if current_user
      if current_user.is_regular?
        if @site_setting.enable_coadmin?
          # Εάν είναι ενεργοποιημένο το coadmin και
          if not current_user.team
            # Δεν είμαι σε κανένα σχολείο και

            if Teacher.with_email(current_user.email).count == 1
              # Το email μου υπάρχει ως εκπαιδευτικός ακριβώς μία φορά

              trg_teacher = Teacher.with_email( current_user.email ).first
              if trg_teacher.coadmin?
                # και έχει οριστεί ο εκπαιδευτικός ως coadmin

                sign_in( trg_teacher.person.user ) #υπενθυμίζω ότι ο person.user είναι ο χρήστης που δημίούργησε αυτό το person.
                redirect_to root_path, 
                  notice: "Ο λογαριασμός #{trg_teacher.person.contact_email} έχει οριστεί ως συνδιαχειριστής του #{trg_teacher.person.user.email}. Έγινε σύνδεση ως #{trg_teacher.person.user.email}"
              end
            end
          end
        end

        if current_user.confirmed?
          if not current_user.team
            if school = School.where(contact_email: current_user.email).first
              if Team.where(school: school).count == 0
                # χρήστης επιβεβαιωμένος με το email της σχολικής μονάδας
                # που κανείς άλλος δεν το έχει δηλώσει 
                # και δεν έχει δηλώσει ακόμα ομάδα
                #
                # Δήλωσέ του την ομάδα (επέλεξέ του το σχολείο)
                #
                team = Team.new
                team.user = current_user
                team.school = school
                team.contact_email = school.contact_email
                team.contact_phone = school.contact_phone
                team.save(validate: false)
              end
            end
          end
        end
      end



      @submissions = policy_scope(Submission).includes(:submission_type)
      @submission_types = SubmissionType.all
      @teams = policy_scope(Team).includes(:school)
      @teachers = policy_scope(Teacher).includes(:person).includes(:speciality).order(team_role: :asc)
      @students = policy_scope(Student).includes(:person).includes(:school_class).order(school_class_id: :asc, last_name: :asc)
    else
      render :welcome, layout: "intro"
    end
  end

  def switch_autonomous_submissions
    authorize current_user, policy_class: WelcomePolicy

    @site_setting.toggle!(:allow_autonomous_submissions)

    redirect_back_or_to root_path, notice: 
      "Επιτυχής ενημέρωση: #{!@site_setting.allow_autonomous_submissions? ? 'απενεργοποιήθηκε': 'ενεργοποιήθηκε'}"
  end

  def switch_hide_students
    authorize current_user, policy_class: WelcomePolicy

    @site_setting.toggle!(:hide_students)

    redirect_back_or_to root_path, notice: 
      "Επιτυχής ενημέρωση: #{ !@site_setting.hide_students? ? 'απενεργοποιήθηκε': 'ενεργοποιήθηκε'}"
  end

  def switch_enable_coadmin
    authorize current_user, policy_class: WelcomePolicy

    @site_setting.toggle!(:enable_coadmin)

    redirect_back_or_to root_path, notice: 
      "Επιτυχής ενημέρωση: #{ !@site_setting.enable_coadmin? ? 'απενεργοποιήθηκε': 'ενεργοποιήθηκε'}"
  end

  def switch_shutdown_previews
    authorize current_user, policy_class: WelcomePolicy

    @site_setting.toggle!(:shut_down_previews)

    redirect_back_or_to root_path, notice: 
      "Επιτυχής ενημέρωση: #{ !@site_setting.shut_down_previews? ? 'απενεργοποιήθηκε': 'ενεργοποιήθηκε'}"
  end

  def set_seminar_participation_deadline
    authorize current_user, policy_class: WelcomePolicy
    return if not params[:date_to_deactivate_seminar_participation]

    @site_setting.update_attribute!(:date_to_deactivate_seminar_participation, 
                                    params[:date_to_deactivate_seminar_participation])

    
    redirect_back_or_to root_path, notice: 
      "Επιτυχής ενημέρωση ημ/νιας: #{@site_setting.date_to_deactivate_seminar_participation}"
  end
end
