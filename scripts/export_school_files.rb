#!/usr/bin/env -S /home/haritak/Coding/contest/bin/rails runner

TARGET_OUTPUT_DIRECTORY = Rails.root.join("exports", Rails.env).to_s
LOG_DIR = TARGET_OUTPUT_DIRECTORY + "/logs"

if Rails.env.production?
  ActiveStorage::Current.url_options = {host: "contest.pdekritis.gr", protocol: "https"}
else
  ActiveStorage::Current.url_options = {host: "localhost", port: 3000}
end

FileUtils.mkdir_p( LOG_DIR ) if not File.exist? LOG_DIR

log = Logger.new "#{LOG_DIR}/log.txt"
log.info "*** New Run #{Time.current} ***"

FileUtils.rm Dir.glob "#{TARGET_OUTPUT_DIRECTORY}/Τελευταία_Ενημέρωση_*"
FileUtils.touch "#{TARGET_OUTPUT_DIRECTORY}/Τελευταία_Ενημέρωση_#{Date.current.to_fs(:db)}"

TrgSubmissionsFolder = "Αρχεία_Σχολείων"

# Συγκεντρωτικό xlsx
summaries_xlsx = Axlsx::Package.new
school_summaries_wb = summaries_xlsx.workbook
school_summaries_ws = school_summaries_wb.add_worksheet(name: "Στοιχεία Σχολείων")
teacher_summaries_ws = school_summaries_wb.add_worksheet(name: "Στοιχεία Εκπαιδευτικών")
submission_summaries_ws = school_summaries_wb.add_worksheet(name: "Στοιχεία Αρχείων Σχολείων")
student_summaries_ws = school_summaries_wb.add_worksheet(name: "Στοιχεία Αρχείων Μαθητών")

school_summaries_ws.add_row ["userid", "λογαριασμός", 
                             "Σχολείο",
                             "Σεμινάριο",
                             "Διαγωνισμός",
                             "επίσημο", #email
                             "επισημο", #τηλέφωνο
                             "δηλωθεν", #email
                             "δηλωθεν" #τηλέφωνο
]

teacher_summaries_ws.add_row ["teachid", "Σχολείο", 
                              "ρόλος", "όνομα", "ειδικότητα", "email", "τηλέφωνο"]

submission_summaries_header = [ "Σχολείο",
                                "emails",
                                "τηλέφωνα"]
SubmissionType.count.times do 
  submission_summaries_header += [ "subid",
                                   "τύπος ",
                                   "οριστικοποίηση",
                                   "πλήθος σελίδων/αρχείων",
                                   "τύπος",
                                   "url"]
end
submission_summaries_ws.add_row submission_summaries_header

student_summaries_header = [ "studid",
                             "Σχολείο",
                             "emails",
                             "τηλέφωνα",
                             "τάξη",
                             "ονοματεπώνυμο",
                             "πατρώνυμο",
                             "μητρώνυμο",
                             "κηδεμόνας",
                             "email κηδ",
                             "τηλ κηδ"]
StudentSubmissionType.mandatory.count.times do 
  student_summaries_header += [ "subid",
                                "τύπος ",
                                "οριστικοποίηση",
                                "πλήθος σελίδων/αρχείων",
                                "τύπος",
                                "url"]

end
student_summaries_ws.add_row student_summaries_header


User.all.each do |user|
  next if not user.is_regular? #neither admin nor secretary
  if not user.team
    log.warn "no team for #{user.email}"
    next 
  end
  next if not user.team.school

  school_name = "#{user.team.school.name}".gsub(/\s/, "_") 

  baseDir = "#{TARGET_OUTPUT_DIRECTORY}/#{TrgSubmissionsFolder}/#{school_name}"
  FileUtils.mkdir_p( baseDir ) if not File.exist? baseDir

  school_summaries_row = []
  submission_summaries_row = []
  student_summaries_row = []

  # xlsx με εκπαιδευτικούς και στοιχεία επικοινωνίας
  p = Axlsx::Package.new
  wb = p.workbook

  school_summaries_row += [user.id, user.email]

  contact_emails = ""
  contact_phones = ""
  wb.add_worksheet(name: 'Στοιχεία Επικοινωνίας') do |sheet|
    if user.team
      sheet.add_row ['Όνομα Σχολείου', user.team.school.name]
      sheet.add_row ['Επίσημο email', user.team.school.contact_email]
      sheet.add_row ['Επίσημο τηλέφωνο', user.team.school.contact_phone]
      sheet.add_row ['Δηλωμένο στην πλατφόρμα email', user.team.contact_email]
      sheet.add_row ['Δηλωμένο στην πλατφόρμα τηλέφωνο', user.team.contact_phone]

      school_summaries_row += [user.team.school.name]
      school_summaries_row += [user.team.seminar_participation_finalized? ? "ΝΑΙ" : "-"]
      school_summaries_row += [user.team.participation_finalized? ? "ΝΑΙ" : "-"]
      school_summaries_row += [user.team.school.contact_email,
         user.team.school.contact_phone, user.team.contact_email, user.team.contact_phone]

      contact_emails += [user.team.school.contact_email, user.team.contact_email].compact.join(", ")
      contact_phones += [user.team.school.contact_phone, user.team.contact_phone].compact.join(", ")
    end
    sheet.add_row ['λογαριασμός πλατφόρμας', user.email]
    sheet.add_row []

    user.teachers.each do |teacher|
      sheet.add_row [teacher.team_role_to_s, teacher.person.short_name, teacher.speciality.to_s, 
                     teacher.person.contact_email, teacher.person.contact_phone,
                     teacher.finalized? ? "Οριστικοποιημένος" : "Μη οριστικοποιημένος"]
      if teacher.finalized?
        teacher_summaries_ws.add_row [teacher.id, teacher.school.name,
                                teacher.team_role_to_s, 
                                teacher.person.short_name, teacher.speciality.to_s, 
                                teacher.person.contact_email, teacher.person.contact_phone]
      contact_emails = [contact_emails, teacher.person.contact_email].compact.join(", ")
      contact_phones = [contact_phones, teacher.person.contact_phone].compact.join(", ")
      end
    end
    5.times do sheet.add_row [] end
    sheet.add_row ['user id', user.id]
    sheet.add_row ['team id', user.team&.id]
  end
  p.serialize "#{baseDir}/Στοιχεία Επικ. Σχολείου και Εκπαιδευτικών.xlsx"

  # Αρχεία Σχολείων
  submission_summaries_row += [ user.team&.school.name ] 
  submission_summaries_row += [ contact_emails ] 
  submission_summaries_row += [ contact_phones ] 
  sub_summaries = []
  user.submissions.order(submission_type_id: :asc).each do |sub|
    trgDir = baseDir
    trgDir = baseDir + "/μη_οριστικοποιημένα" if not sub.finalized?

    FileUtils.mkdir_p( trgDir ) if not File.exist? trgDir

    sub_summaries += [ sub.id ]
    sub_summaries += [ sub.submission_type.submission_type ]
    sub_summaries += [ sub.finalized? ? "ΟΡΙΣΤΙΚΟ" : "μη οριστικό" ]

    fn_extension = "NOT_ANALYZED"
    if sub.submission_file.analyzed?
      if sub.submission_file.content_type =~ /zip/
        fn_extension ="_αριθμός_αρχείων_#{sub.submission_file.metadata['file_count']}.zip"
        sub_summaries += [ sub.submission_file.metadata['file_count'], "ZIP" ]
      elsif sub.submission_file.content_type =~ /pdf/
        fn_extension = "_αριθμός_σελίδων_#{sub.submission_file.metadata['page_count']}.pdf"
        sub_summaries += [ sub.submission_file.metadata['page_count'], "pdf" ]
      else
        fn_extension = "_ΑΓΝΩΣΤΟΣ_ΤΥΠΟΣ"
        sub_summaries += [ "άγνωστος", "άγνωστος" ]
      end
    end

    fn = "#{sub.submission_type.submission_type}" + fn_extension
    fn = fn.gsub /\//, ""
    fn = fn.gsub /\s/, "_"
    trgFn = "#{trgDir}/#{fn}"

    sub_summaries += [ sub.submission_file.url ]

    sub.submission_file.open do |file|
      FileUtils.cp file.path, trgFn
    end
  end # user submissions
  submission_summaries_row += sub_summaries

  school_summaries_ws.add_row school_summaries_row
  submission_summaries_ws.add_row submission_summaries_row

  #students
  user.students.each do |student|
    student_row = [ student.id ]
    student_row += [ student.school.name ]
    student_row += [ contact_emails ]
    student_row += [ contact_phones ]
    student_row += [ student.school_class.description ]
    student_row += [ student.person.short_name ]
    student_row += [ student.person.father_name ]
    student_row += [ student.person.mother_name ]
    student_row += [ student.guardian ]
    student_row += [ student.person.contact_email ]
    student_row += [ student.person.contact_phone ]

    student_submission_row = []
    student.student_submissions.mandatory.order(student_submission_type_id: :asc).each do |stsub|
      student_submission_row += [stsub.id]
      student_submission_row += [stsub.student_submission_type.name]
      student_submission_row += [stsub.finalized? ? "ΟΡΙΣΤ." : "μη οριστ"]
      if stsub.file.analyzed?
        if stsub.file.content_type =~ /pdf/
          student_submission_row += [ stsub.file.metadata['page_count'], "pdf" ]
        else
          student_submission_row += [ "άγνωστος", "άγνωστος" ]
        end
      end
      student_submission_row += [ stsub.file.url ]
    end
    student_row += student_submission_row

    student_summaries_ws.add_row student_row
  end #user student


end # for each user

school_summaries_ws.column_widths *[20]*submission_summaries_header.count
teacher_summaries_ws.column_widths *[20]*submission_summaries_header.count
submission_summaries_ws.column_widths *[20]*submission_summaries_header.count
student_summaries_ws.column_widths *[20]*student_summaries_header.count
summaries_xlsx.serialize "#{TARGET_OUTPUT_DIRECTORY}/#{TrgSubmissionsFolder}/Συγκεντρωτικά_Στοιχεία.xlsx"
