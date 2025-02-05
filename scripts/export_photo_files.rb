#!/usr/bin/env -S /home/haritak/Coding/contest/bin/rails runner


if Rails.env.production?
  Rails.application.routes.default_url_options = {host: "contest.pdekritis.gr", protocol: "https"}
  ActiveStorage::Current.url_options = {host: "contest.pdekritis.gr", protocol: "https"}
else
  Rails.application.routes.default_url_options = {host: "10.9.246.23", port: 3000}
  ActiveStorage::Current.url_options = {host: "10.9.246.23", port: 3000}
end

include Rails.application.routes.url_helpers

TARGET_OUTPUT_DIRECTORY = Rails.root.join("exports", Rails.env).to_s
LOG_DIR = TARGET_OUTPUT_DIRECTORY + "/logs"

FileUtils.mkdir_p( LOG_DIR ) if not File.exist? LOG_DIR

log = Logger.new "#{LOG_DIR}/log.txt"
log.info "*** New Run #{Time.current} ***"

FileUtils.rm Dir.glob "#{TARGET_OUTPUT_DIRECTORY}/Τελευταία_Ενημέρωση_Φωτογραφιών_*"
FileUtils.touch "#{TARGET_OUTPUT_DIRECTORY}/Τελευταία_Ενημέρωση_Φωτογραφιών_#{Date.current.to_fs(:db)}"

TrgSubmissionsFolder = "#{TARGET_OUTPUT_DIRECTORY}/Φωτογραφίες"


def save_photo( main_cat_dir, sub, do_save = true )
  trgDir = main_cat_dir + "/" + sub.student_submission_type.name
  trgDir += "/μη_οριστ" if not sub.finalized?
  FileUtils.mkdir_p( trgDir ) if not File.exist? trgDir

  trgFn = "#{trgDir}/#{sub.school&.is_spedu? ? "e" : ""}#{sub.school&.id}_#{sub.student.id}_#{sub.id}.jpeg"

  if do_save
    if File.exist? trgFn
      puts "#{trgFn} already exists."
    else
      sub.file.open do |file|
        FileUtils.cp file.path, trgFn
      end
    end
  end
  trgFn
end

def create_xlsx( trgDir, students )

  #create one xlsx for each category
  xls = {}
  work_sheets = {}
  StudentSubmissionType.optional.each do |sst|
    xls[ sst.name ] = Axlsx::Package.new
    work_sheets[ sst.name ] = xls[ sst.name ].workbook.add_worksheet(name: "τίτλοι")
    work_sheets[ sst.name ].add_row [ "stsubid",
                                      "Σχολείο",
                                      "Ειδικό;",
                                      "Υποβολή?",
                                      "τάξη",
                                      "τύπος τάξης",
                                      "ονοματεπώνυμο",
                                      "όνομα πατέρα",
                                      "όνομα μητέρας",
                                      "κηδεμόνας",
                                      "email",
                                      "τηλέφωνο",
                                      "φώτο οριστ?",
                                      "τίτλος",
                                      "φωτογραφία original",
                                      "φωτογραφία 50χ50",
                                      "φωτογραφία 30χ30",
    ]
  end

  students.each do |student|
    student.student_submissions.optional.order(student_submission_type_id: :asc).each do |sub|
      sheet = work_sheets[ sub.student_submission_type.name ]
      student_row = [ "#{sub.id}", 
                      student.user.team&.school&.name,
                      student.user.team&.school&.is_spedu? ? "ΕΙΔΙΚΟ" : "",
                      student.user.team&.participation_finalized? ? "ναι" : "ΟΧΙ!",
                      student.school_class.school_class,
                      student.school_class.school_type.school_type,
                      student.person.short_name,
                      student.person.father_name,
                      student.person.mother_name,
                      student.guardian,
                      student.person.contact_email,
                      student.person.contact_phone,
                      sub.finalized? ? "ΟΡΙΣΤ" : "μη οριστ.",
                      sub.title,
                      url_for(sub.file), #rails_blob_path(sub.file, only_path: true),
                      url_for(sub.file.representation(resize_to_limit: [50, 50]).processed),
                      url_for(sub.file.representation(resize_to_limit: [30, 30]).processed),
                      # The URLs below are by configuration **private**,
                      # so are valid for a specific time!
                      # Use of url_for above, provides a stable link
                      # (see more on ActiveStorage documentation)
                      #sub.file.url,
                      #sub.file.representation(resize_to_limit: [50, 50]).processed.url,
                      #sub.file.representation(resize_to_limit: [30, 30]).processed.url,
      ]
      row = sheet.add_row student_row, height: 100, widths: [100, :auto, 30] + [:auto]*10
      filename = save_photo(trgDir, sub, false) #just get the filename
      # TODO μάλλον το κενό στο filename δημιουργεί προβλήματα: 
      #sheet.add_image image_src: filename, start_at: "A#{row.row_index}", width: 100, height: 100
    end
  end

  FileUtils.mkdir_p( trgDir ) if not File.exist? trgDir
  StudentSubmissionType.optional.each do |sst|
    FileUtils.rm "#{trgDir}/τίτλοι.#{sst.name}.xlsx" if File.exist? "#{trgDir}/τίτλοι.#{sst.name}.xlsx"
    xls[ sst.name ].serialize "#{trgDir}/τίτλοι.#{sst.name}.xlsx"
  end
end

main_cat_dir = "#{TrgSubmissionsFolder}/Ενήλικες"
create_xlsx main_cat_dir, Student.adults
Student.adults.each do |student|

  student.student_submissions.optional.each do |sub|

    save_photo(main_cat_dir, sub)

  end

end

main_cat_dir = "#{TrgSubmissionsFolder}/Γυμνάσια"
create_xlsx main_cat_dir, Student.kids.gymnasio
Student.kids.gymnasio.each do |student|

  student.student_submissions.optional.each do |sub|

    save_photo(main_cat_dir, sub)

  end

end

main_cat_dir = "#{TrgSubmissionsFolder}/Λύκεια"
create_xlsx main_cat_dir, Student.kids.lykeio
Student.kids.lykeio.each do |student|

  student.student_submissions.optional.each do |sub|

    save_photo(main_cat_dir, sub)

  end

end
