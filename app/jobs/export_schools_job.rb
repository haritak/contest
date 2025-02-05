class ExportSchoolsJob < ActiveJob::Base

  # Set the Queue as Default
  queue_as :default

  rescue_from ActiveJob::DeserializationError do |exception|
    # handle a deleted user record
    Rails.logger.warn "some job was deleted before its execution ..."
  end

  def perform(generated_file_id:)
    gf = nil
    begin
      gf = GeneratedFile.find( generated_file_id )
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.warn "Couldn't find job. Job was destroyed before execution ? :" + e.message
      return
    end

    containing_directory = File.dirname gf.filename
    FileUtils.mkdir_p containing_directory if not File.exist? containing_directory

    Exports::Teams.create gf.filename

    gf.status = "READY"
    gf.save!
  end
end
