class UserMailer < ApplicationMailer

  def student_invitation
    @invitation = params[:invitation]
    student_email = @invitation.student.person.contact_email

    mail(to: student_email, 
         bcc: "mail@3rd-photocontest.pdekritis.gr",
         subject: 'Σύνδεσμος για υποβολή αρχείων')
  end

  def school_request_confirmation
    @team = params[:team]

    email = @team.school.contact_email.strip

    mail(to: email, 
         #cc: @team.contact_email.strip, ΜΟΝΟ ΣΤΟ ΕΠΙΣΗΜΟ, πουθενά αλλού!
         bcc: "mail@3rd-photocontest.pdekritis.gr",
         subject: 'Επιβεβαίωση Λογαριασμού Σχολικής Μονάδας')
  end

  def school_confirmed
    @team = params[:team]

    email = @team.user.email
    other_emails = []
    @team.user.teachers.finalized.each do |t| #Μην βάλεις τους finalized, γιατί μπορεί να μην έχουν κάνει ακόμα τον εαυτό τους finalized!
      if t.person.contact_email and !t.person.contact_email.empty?
        other_emails << t.person.contact_email
      end
    end
    other_emails = other_emails.join(";")

    mail(to: email, 
         cc: other_emails,
         bcc: "mail@3rd-photocontest.pdekritis.gr",
         subject: 'Ολοκληρώθηκε η επιβεβαίωση λογαριασμού σχολικής μονάδας')
  end

  def send_receipt_of_seminar_participation
    @team = params[:team]

    email = @team.user.email
    other_emails = [@team.school.contact_email]
    @team.user.teachers.finalized.each do |t|
      if t.person.contact_email and !t.person.contact_email.empty?
        other_emails << t.person.contact_email
      end
    end
    other_emails = other_emails.join(";")

    bcc_secretaries = "" # DEACTIVATED User.secretaries.map(&:email).join(";")

    mail(to: email, 
         cc: other_emails,
         bcc: "mail@3rd-photocontest.pdekritis.gr;#{bcc_secretaries}",
         subject: 'Επιτυχής υποβολή συμμετοχής Σχολικής Μονάδας στο Σεμινάριο Φωτογραφίας')
  end

  def send_receipt_of_participation
    @team = params[:team]

    email = @team.user.email
    other_emails = [@team.school.contact_email]
    @team.user.teachers.finalized.each do |t|
      if t.person.contact_email and !t.person.contact_email.empty?
        other_emails << t.person.contact_email
      end
    end
    other_emails = other_emails.join(";")

    bcc_secretaries = "" # DEACTIVATED User.secretaries.map(&:email).join(";")

    mail(to: email, 
         cc: other_emails,
         bcc: "mail@3rd-photocontest.pdekritis.gr;#{bcc_secretaries}",
         subject: 'Επιτυχής υποβολή συμμετοχής Σχολικής Μονάδας στο Διαγωνισμό Φωτογραφίας')
  end

end
