module Papyrus
  class StudentLoader

    DEFAULT_OPTIONS = {
      ignore_first_line: true,
      fields_order: [
        "student_number",
        "first_name",
        "last_name",
        "email",
        "cds_counsellor",
        "cds_counsellor_email",
        "accessibility_lab_access",
        "book_retrieval",
        "alternate_format_required",
        "format_pdf",
        "format_large_print",
        "format_word",
        "format_braille",
        "format_other",
        "format_note",
        "request_form_signed_on"
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

      ## GET COORDINATOR LIST, for later processing
      coordinator_list = User.active.coordinators.collect { |u| u.id }
      ## ENSURE first id in the list is not the most recent assigned coordinator
      # if Student.most_recent_students(1).size > 0
      #   last_assigned_coordinator_id = Student.most_recent_students(1).first.details.transcription_coordinator_id
      #   if last_assigned_coordinator_id == coordinator_list.last
      #     id = coordinator_list.pop
      #     coordinator_list.insert(0, id)
      #   end
      # end

      status = { updated: [], created: [], errors: [] }

      students_list.each do |student_array|

        params = Student.build_hash_from_array(student_array, @options[:fields_order])
        student = Student.where("student_details.student_number = ?", params[:student_details_attributes][:student_number]).references(:student_details).includes(:student_details).first


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

          unless student.valid?
            status[:errors].push [student_array, student.errors.messages]
          end
          
        else
          # if new student, should create it

          log "New Student, registering new student"
          student = Student.new(params)
          student.username = student.details.student_number
          student.role = User::STUDENT_USER

          if PapyrusSettings.import_auto_assign_coordinator == PapyrusSettings::TRUE

            auto_id = coordinator_list.pop # pop the id off the list (Last In )

            student.details.transcription_coordinator_id = auto_id
            student.details.transcription_assistant_id = auto_id

            coordinator_list.insert(0, auto_id) # put the id back at the end of the list (Last Out)
          else
            student.details.transcription_coordinator_id = @options[:coordinator_id]
            student.details.transcription_assistant_id = @options[:coordinator_id]
          end

          student.details.preferred_phone = "not provided"
          student.created_by_user_id = @options[:created_by_id]


          if student.save
            status[:created].push student.id
            log "Saved: #{student.id}"

            if PapyrusSettings.import_send_welcome_email_to_student == PapyrusSettings::TRUE
              student.audit_comment = "Sending welcome email."
              StudentMailer.welcome_email(student, student.created_by).deliver_later
              student.email_sent_at = Time.zone.now
              student.save
            end

            if PapyrusSettings.import_notify_coordinator == PapyrusSettings::TRUE && student.details.transcription_coordinator
              body = "A student, #{student.name} has been assigned to you. \n\n -- \nPapyrus"
              ReportMailer.mail_report(student.details.transcription_coordinator.email, body, "New Student Assigned").deliver_later
            end

          else
            status[:errors].push [student_array, student.errors.messages]
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
