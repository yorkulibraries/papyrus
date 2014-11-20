require 'ostruct'

DEFAULT_OPTIONS = {
  csv_ignore_first_line: true,
  csv_fields_order: [
    "student_number", "first_name", "last_name", "email", "cds_counsellor", "cds_counsellor_email","request_form_signed_on",
    "accessibility_lab_access", "book_retrieval", "alternate_format_required", "format_pdf", "format_large_print", "format_daisy", "format_braille",
    "format_word", "format_other", "format_note"
  ],
  deactivate_all_students: false,
  send_welcome_email: false
}

namespace :import do
  desc "Papyrus Import Tasks"

  task :students => :environment do
    log "Importing Students from STDIN"

    options = get_options()

    STDIN.each_line do |line|
      puts line
    end

    puts options.inspect
  end


  def get_options
    options = OpenStruct.new(DEFAULT_OPTIONS)

    options.csv_ignore_first_line = true if ENV["IGNORE_FIRST_LINE"] == "true"
    options.csv_fields_order = ENV["FIELDS_ORDER"].split(" ") if ENV["FIELDS_ORDER"]
    options.deactivate_all_students = true if ENV["DEACTIVATE_ALL_STUDENTS"] == true
    options.send_welcome_email = true if ENV["SEND_WELCOME_EMAIL"] == true

    options
  end


    # Crude logging
  def log(string)
    if ENV['DEBUG'] != nil
      puts string
    end
  end

end
