require 'ostruct'

OPTIONS = {
  ignore_first_line: true,
  csv_headers: [
    "student_number", "firstname", "lastname", "email", "cds_counsellor", "cds_counsellor_email","request_form_signed_on",
    "accessibility_lab_access", "book_retrieval", "alternate_format_required", "format_pdf", "format_large_print", "format_daisy", "format_braille",
    "format_word", "format_other", "format_note"
  ]
}

namespace :import do
  desc "Papyrus Import Tasks"

  task :students => :environment do
    log "Importing Students from STDIN"

    STDIN.each_line do |line|
      puts line
    end
  end




    # Crude logging
  def log(string)
    if ENV['DEBUG'] != nil
      puts string
    end
  end

end
