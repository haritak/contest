#!/usr/bin/env -S /home/haritak/Coding/contest/bin/rails runner

TARGET_OUTPUT_DIRECTORY = Rails.root.join("exports", Rails.env).to_s
LOG_DIR = TARGET_OUTPUT_DIRECTORY + "/logs"

FileUtils.mkdir_p( LOG_DIR ) if not File.exist? LOG_DIR

log = Logger.new "#{LOG_DIR}/log.txt"
log.info "*** New Run #{Time.current} ***"

FileUtils.rm Dir.glob "#{TARGET_OUTPUT_DIRECTORY}/Τελευταία_Ενημέρωση_Αρχείων_Μαθητών_*"
FileUtils.touch "#{TARGET_OUTPUT_DIRECTORY}/Τελευταία_Ενημέρωση_Αρχείων_Μαθητών_#{Date.current.to_fs(:db)}"

TrgSubmissionsFolder = "Αρχεία_Μαθητών"
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

  # xlsx με εκπαιδευτικούς, στοιχεία επικοινωνίας και μαθητές
  p = Axlsx::Package.new
  wb = p.workbook

  wb.add_worksheet(name: 'Λίστα Μαθητ_ Σχολείου') do |sheet|
    if user.team
      sheet.add_row ['Όνομα Σχολείου', user.team.school.name]
      sheet.add_row ['Επίσημο email', user.team.school.contact_email]
      sheet.add_row ['Επίσημο τηλέφωνο', user.team.school.contact_phone]
      sheet.add_row ['Δηλωμένο στην πλατφόρμα email', user.team.contact_email]
      sheet.add_row ['Δηλωμένο στην πλατφόρμα τηλέφωνο', user.team.contact_phone]
    end
    sheet.add_row ['λογαριασμός πλατφόρμας', user.email]
    sheet.add_row []

    user.teachers.each do |teacher|
      sheet.add_row [teacher.team_role_to_s, teacher.person.short_name, teacher.speciality.to_s, 
                     teacher.person.contact_email, teacher.person.contact_phone,
                     teacher.finalized? ? "Οριστικοποιημένος" : "Μη οριστικοποιημένος"]
    end
    5.times do sheet.add_row [] end

    sheet.add_row ['user id', user.id]
    sheet.add_row ['team id', user.team&.id]

    3.times do sheet.add_row [] end

    user.students.each_with_index do |student, idx|
      sheet.add_row [idx, "student_#{student.id}",
                    user.team.school, student.school_class.school_class, student.is_adult? ? "Ενήλικος" : "ανήλικος",
                    student.person.last_name, student.person.first_name, student.person.father_name, student.person.mother_name,
                    student.guardian, student.person.contact_phone, student.person.contact_email,
                    "pdfs: #{student.mandatory_counter}",
                    "φώτο: #{student.optional_counter}",
                    "πλήθος οριστικ: #{student.finalized_counter}"]
    end
  end
  p.serialize "#{baseDir}/Λίστα Μαθητ_ Σχολείου.xlsx"

  # Μαθητών
  user.students.each do |student|
    student_home_directory = "#{baseDir}/student_#{student.id}"

    student.student_submissions.mandatory.each do |sub|
      trgDir = student_home_directory
      trgDir = student_home_directory + "/μη_οριστικοποιημένα" if not sub.finalized?

      FileUtils.mkdir_p( trgDir ) if not File.exist? trgDir

      fn_extension = "NOT_ANALYZED"
      if sub.file.analyzed?
        if sub.file.content_type =~ /zip/
          fn_extension ="_αριθμός_αρχείων_#{sub.file.metadata['file_count']}.zip"
        elsif sub.file.content_type =~ /pdf/
          fn_extension = "_αριθμός_σελίδων_#{sub.file.metadata['page_count']}.pdf"
        elsif sub.file.content_type =~ /jpeg/
          fn_extension = ".jpeg"
        elsif sub.file.content_type =~ /png/
          fn_extension = ".png"
        else
          fn_extension = "_ΑΓΝΩΣΤΟΣ_ΤΥΠΟΣ"
        end
      end

      fn = "#{sub.student_submission_type.name}" + fn_extension
      fn = fn.gsub /\//, ""
      fn = fn.gsub /\s/, "_"
      trgFn = "#{trgDir}/#{fn}"

      sub.file.open do |file|
        FileUtils.cp file.path, trgFn
      end
    end

    titles_xlsx = Axlsx::Package.new
    titles_wb = titles_xlsx.workbook
    titles_wb.add_worksheet(name: "Τίτλοι") do |sheet|
      sheet.add_row [user.team.school]
      sheet.add_row ["student_id#{student.id}", 
                     student.person.short_name,
                     student.person.father_name,
                     student.person.mother_name]
      sheet.add_row []
      student.student_submissions.optional.each do |sub|
        sheet.add_row ["ssid_#{sub.id}",
                       sub.student_submission_type.name,
                       sub.file.filename,
                       sub.title ]
      end
    end
    FileUtils.mkdir_p student_home_directory if not File.exist? student_home_directory
    titles_xlsx.serialize "#{student_home_directory}/τίτλοι.xlsx"

    student.student_submissions.optional.each do |sub|
      trgDir = student_home_directory
      trgDir = student_home_directory + "/μη_οριστικοποιημένα" if not sub.finalized?

      FileUtils.mkdir_p( trgDir ) if not File.exist? trgDir

      fn_extension = "NOT_ANALYZED"
      if sub.file.analyzed?
        if sub.file.content_type =~ /zip/
          fn_extension ="_αριθμός_αρχείων_#{sub.file.metadata['file_count']}.zip"
        elsif sub.file.content_type =~ /pdf/
          fn_extension = "_αριθμός_σελίδων_#{sub.file.metadata['page_count']}.pdf"
        elsif sub.file.content_type =~ /jpeg/
          fn_extension = ".jpeg"
        elsif sub.file.content_type =~ /png/
          fn_extension = ".png"
        else
          fn_extension = "_ΑΓΝΩΣΤΟΣ_ΤΥΠΟΣ"
        end
      end

      fn = "#{sub.student_submission_type.name}_ssid#{sub.id}" + fn_extension
      fn = fn.gsub /\//, ""
      fn = fn.gsub /\s/, "_"
      trgFn = "#{trgDir}/#{fn}"

      sub.file.open do |file|
        FileUtils.cp file.path, trgFn
      end
    end
  end
end
