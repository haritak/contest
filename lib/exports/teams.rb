class Exports::Teams

  def self.create(filename)
    filename = "/tmp/#{SecureRandom.urlsafe_base64}.xlsx" if not filename 

    xlsx = Axlsx::Package.new
    wb = xlsx.workbook
    ws = wb.add_worksheet(name: "Στοιχεία Σχολείων")
    ws.add_row
    ws.add_row [nil, "Ημερομηνία δημιουργίας αρχείου:", DateTime.now]
    ws.add_row
    ws.add_row ["uid", "school", "seminar", "contest", "email", "extra", "description"]

    User.all.each do |u|
      next if not u.team
      next if not u.team.finalized?

      std = [u.id, u.team.school.name, 
             u.team.seminar_participation_finalized? ? "ΟΡΙΣΤ.ΣΕΜ." : "δ/ο σεμ.", 
             u.team.participation_finalized? ? "ΟΡΙΣΤ.ΔΙΑΓ" : "δ/ο διαγ"]

      ws.add_row std + [u.email, nil, "email λογαριασμού πλατφόρμας"]
      ws.add_row std + [u.team.contact_email, nil, "δηλωθέν email σχολείου"]
      ws.add_row std + [u.team.school.contact_email, nil, "επίσημο email σχολείου"]
      u.teachers.each do |t|
        next if not t.finalized?

        ws.add_row std + [t.person.contact_email, t.person.short_name, t.team_role, t.person.contact_phone]
      end
      if u.submissions.count == 0
        ws.add_row [nil, "Δεν υπάρχουν αρχεία σχολικής μονάδας!"]
      elsif u.submissions.any? { |s| not s.reviewed? }
        ws.add_row [nil, "ΠΡΟΣΟΧΗ: Υπάρχουν αρχεία της σχολικής μονάδας που ΔΕΝ έχουν γίνει marked ως reviewed."]
        u.submissions.each do |s|
          ws.add_row [nil, s.submission_type.submission_type, s.reviewer_notes] if s.reviewer_notes.present?
        end
      else
        ws.add_row [nil, "όλα τα αρχεία της σχολικής μονάδας έχουν ελεγχθεί"]
      end

      ws.add_row
    end



    xlsx.serialize( filename )

    puts filename
    filename
  end
end
