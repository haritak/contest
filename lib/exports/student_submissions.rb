class Exports::StudentSubmissions
  include Rails.application.routes.url_helpers

  def self.create(filename)
    filename = "/tmp/#{SecureRandom.urlsafe_base64}.xlsx" if not filename 
    if Rails.env.production?
      Rails.application.routes.default_url_options = {host: "contest.pdekritis.gr", protocol: "https"}
      ActiveStorage::Current.url_options = {host: "contest.pdekritis.gr", protocol: "https"}
    else
      Rails.application.routes.default_url_options = {host: "10.9.246.23", port: 3000}
      ActiveStorage::Current.url_options = {host: "localhost", port: 3000}
    end

    xlsx = Axlsx::Package.new
    wb = xlsx.workbook
    ws = wb.add_worksheet(name: "Αρχεία Μαθητών κ Μαθητριών")
    ws.add_row
    ws.add_row [nil, "Ημερομηνία δημιουργίας αρχείου:", DateTime.now]
    ws.add_row
    ws.add_row ["uid", "school", "contest"] + 
      ["email λογαριασμού πλατφόρμας", "δηλωθέν email σχολείου", "επίσημο email σχολείου"] +
      ["emails οριστικοποιημένων εκπαιδευτικών"] +
      ["student id", "φύλο", "ενήλικος;", "επώνυμο", "όνομα", "πατρώνυμο", "email", "τάξη", "τύπος σχολείου", "Είναι Ειδικής;", ""] +
      ["student submission id", "τύπος αρχείου", "τίτλος", "url", "marked_ok?", "review notes", "ετικέτες"]

    User.all.each do |u|
      next if not u.team
      next if not u.team.finalized?

      std =  [u.id, u.team.school.name, u.team.participation_finalized? ? "ΟΡΙΣΤ.ΔΙΑΓ" : "δ/ο διαγ"]
      std += [u.email, u.team.contact_email, u.team.school.contact_email ]
      std += [u.teachers.finalized.map { |t| t.person.contact_email }.join(", ")]

      u.students.each do |student|
        not_finalized_files_counter = 0

        student_row = std
        student_row += [student.id,
                        student.person.gender,
                        student.is_adult? ? "ΕΝΗΛΙΚ_" : "",
                        student.person.last_name,
                        student.person.first_name,
                        student.person.father_name,
                        #student.person.mother_name,
                        #student.guardian,
                        student.person.contact_email,
                        #student.person.contact_phone,
                        student.school_class.school_class,
                        student.school_class.school_type.school_type,
                        student.school.is_spedu? ? "ΕΙΔΙΚΗΣ" : "",
        '']

        student.student_submissions.mandatory.each do |mss|
          not_finalized_files_counter += 1 if not mss.finalized?
          next if not mss.finalized?
          student_row += [mss.id,
                          mss.student_submission_type.name,
                          mss.title,
                          Rails.application.routes.url_helpers.url_for(mss.file),
                          mss.review_marked_ok?,
                          mss.review_notes,
                          ""
          ]

        end
        student.student_submissions.optional.each do |mss|
          not_finalized_files_counter += 1 if not mss.finalized?
          next if not mss.finalized?
          student_row += [mss.id,
                          mss.student_submission_type.name,
                          mss.title,
                          Rails.application.routes.url_helpers.url_for(mss.file),
                          mss.review_marked_ok?,
                          mss.review_notes
          ] + [mss.tags.map(&:name).uniq.sort.join(", ")]

        end

        student_row += [ " υπάρχουν #{not_finalized_files_counter} μη οριστικά αρχεία που δεν φαίνονται! " ] if not_finalized_files_counter > 0 

        ws.add_row student_row
      end

    end

    ws.column_widths( *([20]*40) )

    xlsx.serialize( filename )

    puts filename
    filename
  end
end
