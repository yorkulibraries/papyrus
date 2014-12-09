module Papyrus
  class StudentLoader

    DEFAULT_OPTIONS = {
      ignore_first_line: true,
      fields_order: [
        "student_number", "first_name", "last_name", "email", "cds_counsellor", "cds_counsellor_email","request_form_signed_on",
        "accessibility_lab_access", "book_retrieval", "alternate_format_required", "format_pdf", "format_large_print", "format_daisy", "format_braille",
        "format_word", "format_other", "format_note"
      ],
      coordinator_id: 1,
      created_by_id: 1
    }

    def initialize
      @options = DEFAULT_OPTIONS
    end


    def from_list(students_list, options=nil)
      return nil if students_list == nil || !students_list.kind_of?(Array) # If nil or array return

      process_options(options)

      # ignore first line if required
      students_list.shift if @options[:ignore_first_line]

      status = { updated: [], created: [], errors: [] }
      
      students_list.each do |student_array|

        params = Student.build_hash_from_array(student_array, @options[:fields_order])
        student = Student.where("student_details.student_number = ?", params[:student_details_attributes][:student_number]).includes(:student_details).first


        if student
          # if existing student, should update it
          log "Found Student, Updatting Student # #{student.id}"
          params.keys.each do |key|
            if key == :student_details_attributes
              params[:student_details_attributes].keys.each do |i|
                student.details.update_attribute(i, params[:student_details_attributes][i])
              end
            else
              student.update_attribute(key, params[key])
            end
          end

          status[:updated].push student.id
        else
          # if new student, should create it

          log "New Student, registering new student"
          student = Student.new(params)
          student.username = student.details.student_number
          student.role = User::STUDENT_USER
          student.details.transcription_coordinator_id = @options[:coordinator_id]
          student.details.transcription_assistant_id = @options[:coordinator_id]
          student.details.preferred_phone = "not provided"
          student.created_by_user_id = @options[:created_by_id]


          if student.save
            status[:created].push student.id
            log "Saved: #{student.id}"
          else
            status[:errors].push student_array
          end
        end


      end

      return status ## return status

    end

    def process_options(options=nil)
      if options != nil
        # Merge options that might been passed
        @options.merge!(options)
      else
        load_env_options  # try loading options from environment
      end

      @options
    end

    def load_env_options
      @options[:ignore_first_line] = true if ENV["IGNORE_FIRST_LINE"] == "true"
      @options[:fields_order] = ENV["FIELDS_ORDER"].split(" ") if ENV["FIELDS_ORDER"]
      @options[:deactivate_all_students] = true if ENV["DEACTIVATE_ALL_STUDENTS"] == "true"
      @options[:coordinator_id] = ENV["COORDINATOR_ID"].to_i if ENV["COORDINATOR_ID"]
      @options[:created_by_id] = ENV["CREATOR_ID"].to_i if ENV["CREATOR_ID"]
    end

    def get_env_options_names
      return @options.keys.collect{ |k| k.upcase }.join(", ")
    end

    # Crude logging
    def log(string)
      if ENV['DEBUG'] != nil
        puts string
      end
    end

  end # end class
end # end module
