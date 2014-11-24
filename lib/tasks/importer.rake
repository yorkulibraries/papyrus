require 'ostruct'
require 'csv'

DEFAULT_OPTIONS = {
  csv_ignore_first_line: true,
  csv_fields_order: [
    "student_number", "first_name", "last_name", "email", "cds_counsellor", "cds_counsellor_email","request_form_signed_on",
    "accessibility_lab_access", "book_retrieval", "alternate_format_required", "format_pdf", "format_large_print", "format_daisy", "format_braille",
    "format_word", "format_other", "format_note"
  ],
  deactivate_all_students: false,
  send_welcome_email: false,
  default_transcription_coordinator_id: 1,
  created_by_id: 1
}

namespace :import do
  desc "Papyrus Import Tasks"

  task :students => :environment do
    log "Importing Students from STDIN"

    options = get_options()

    students = Array.new
    # Parse CSV
    STDIN.each_line do |line|
      data = CSV.parse(line).first
      students.push data
    end

    # ignore first line if required
    students.shift if options.csv_ignore_first_line

    # Iterate
    students.each do |data_array|

      params = Student.build_hash_from_array(data_array, options.csv_fields_order)

      student = Student.where("student_details.student_number = ?", params[:student_details_attributes][:student_number]).includes(:student_details).first

      if student
        log "Found Student, Updatting params #{student.valid?} #{student.last_name} #{student.details.id}"
        params.keys.each do |key|
          if key == :student_details_attributes
            params[:student_details_attributes].keys.each do |i|
              student.details.update_attribute(i, params[:student_details_attributes][i])
            end
          else
            student.update_attribute(key, params[key])
          end
        end

        log "#{student.details.id}"
      else
        log "New Student, Saving new student"
        student = Student.new(params)
        student.username = student.details.student_number
        student.role = User::STUDENT_USER
        student.details.transcription_coordinator_id = options.default_transcription_coordinator_id
        student.details.transcription_assistant_id = options.default_transcription_coordinator_id
        student.details.preferred_phone = "not provided"
        student.created_by_id = options.created_by_id

        unless student.valid?
          log "#{student.errors.messages}"
        end

        student.save

        log "Saved: #{student.id}"
      end
    end


  end


  def get_options
    options = OpenStruct.new(DEFAULT_OPTIONS)

    options.csv_ignore_first_line = true if ENV["IGNORE_FIRST_LINE"] == "true"
    options.csv_fields_order = ENV["FIELDS_ORDER"].split(" ") if ENV["FIELDS_ORDER"]
    options.deactivate_all_students = true if ENV["DEACTIVATE_ALL_STUDENTS"] == true
    options.send_welcome_email = true if ENV["SEND_WELCOME_EMAIL"] == true
    options.default_transcription_coordinator_id = ENV["COORDINATOR"] if ENV["COORDINATOR"]
    options.created_by_id = ENV["CREATOR_ID"] if ENV["CREATOR_ID"]

    options
  end


    # Crude logging
  def log(string)
    if ENV['DEBUG'] != nil
      puts string
    end
  end

end
