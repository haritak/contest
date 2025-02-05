require 'zip'

module Analyzer
  class ZipAnalyzer < ActiveStorage::Analyzer
    # Only run this analyzer on PDF files
    def self.accept?(blob) = blob.content_type == 'application/zip'

    def self.analyze_later?
      true
    end 

    def metadata
      no_files = download_blob_to_tempfile { |file| Zip::File.open(file).count }
      {
        file_count: no_files
      }
    end
  end
end

