require_relative "../../lib/analyzer/pdf_analyzer"
require_relative "../../lib/analyzer/zip_analyzer"

# https://www.reddit.com/r/rails/comments/14uwgdm/count_number_of_pages_in_pdf/
# Add the analyzer to the default set so that it gets run on every upload
Rails.application.config.active_storage.analyzers << Analyzer::PdfAnalyzer
Rails.application.config.active_storage.analyzers << Analyzer::ZipAnalyzer
