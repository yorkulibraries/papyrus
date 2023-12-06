# frozen_string_literal: true

class My::CourseSyncController < My::BaseController
  skip_before_action :check_terms_acceptance, :sync_courses

  def sync
    @student = current_user

    course_list = request.headers[PapyrusSettings.course_listing_header]

    # if  course list  is nil or empty, remove all student course associations
    # Then redirect to student view
    course_code_parser = Papyrus::YorkuCourseCodeParser.new

    list = course_code_parser.unique_codes_only(course_list, PapyrusSettings.course_listing_separator)
    current_list = @student.courses.collect(&:code)

    @student.courses.delete_all
    unless list.size.zero?

      list.each do |code|
        course = Course.find_by_code(code)

        if course.nil?

          # check if term exists, if not, create it
          term_details = course_code_parser.term_details(code)
          term = Term.where(start_date: term_details[:start_date], end_date: term_details[:end_date]).first
          if term.nil?
            term = Term.new(name: term_details[:name], start_date: term_details[:start_date],
                            end_date: term_details[:end_date])
            term.save
          end

          # create course
          course = Course.new(code:, title: course_code_parser.short_code(code), term:)
          course.save

        end

        sc = StudentCourse.new(student: @student, course:)
        result = sc.save(validate: false)
      end
    end

    @courses_added = list - current_list
    @courses_removed = current_list - list

    ## Send the email to coordinator and/or assistant if different. If there are changes
    notify_coordinator(@student, @courses_added, @courses_removed)

    flash[:notice] = 'Courses synced'
    redirect_to my_student_portal_path
  end

  private

  def authorize_controller
    authorize! :show, :student
  end

  def notify_coordinator(student, courses_added, courses_removed)
    return unless courses_added.size.positive? || courses_removed.size.positive?

    coordinator = student.details.transcription_coordinator || User.new(email: 'noreply@library.yorku.ca')
    assistant = student.details.transcription_assistant || User.new

    message = <<-HEREDOC
        Hello,

        The list of courses, which #{student.name} is enrolled in, has been updated. Please review below:

        #{"Added:\n" if courses_added.size.positive?}
        #{courses_added.join("\n") if courses_added.size.positive?}

        #{"Removed:\n" if courses_removed.size.positive?}
        #{courses_removed.join("\n") if courses_removed.size.positive?}

    HEREDOC

    ReportMailer.mail_report([coordinator.email, assistant.email], message,
                             "Course List Updated: #{student.name}").deliver_later
  end
end
