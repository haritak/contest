module Analyzer
  class PdfAnalyzer < ActiveStorage::Analyzer
    # Only run this analyzer on PDF files
    def self.accept?(blob) = blob.content_type == 'application/pdf'

    def self.analyze_later?
      true
    end 

    def metadata
      no_pages = download_blob_to_tempfile { |file| PDF::Reader.new(file).page_count }
      {
        page_count: no_pages
      }
    end
  end
end

