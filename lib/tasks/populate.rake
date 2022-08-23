# frozen_string_literal: true

namespace :db do
  desc 'Papyrus Related Tasks'

  task populate: :environment do
    require 'populator'
    require 'faker'

    [AcquisitionRequest, Item, Attachment, Student, StudentDetails, ItemConnection, Note, User, Term, Course,
     ItemCourseConnection, AccessCode].each(&:delete_all)

    puts 'Create all user accounts'

    index = 0

    User.populate User::ROLE_NAMES.size do |user|
      user.username = User::ROLE_NAMES[index]
      user.first_name = User::ROLE_NAMES[index].titleize.to_s
      user.last_name = 'User'
      user.email = "#{user.username}@utest.yorku.ca"
      user.inactive = false
      user.blocked = false
      user.role = User::ROLE_NAMES[index]
      index += 1

      if user.role == User::STUDENT_USER
        user.type = Student.to_s
        user.created_by_user_id = 1
        user.role = User::STUDENT_USER
      end
    end

    puts 'Generating Items and Files'

    Item.populate 10..100 do |item|
      item.title = Populator.words(4..6).titleize
      item.unique_id = 1000..100_000
      item.user_id = 1..User::ROLE_NAMES.size

      item.item_type = %w[book article course_kit]
      item.callnumber = 'GH 457 1981 AB'
      item.author = Faker::Name.name

      attachment_counter = 0
      Attachment.populate 1..4 do |attachment|
        attachment.item_id = item.id
        attachment.name = ['Chapter 1', 'Chapter 2', 'Chapter 3', 'Chapter 4', 'Chapter 5', 'Ch1', 'Ch2', 'Ch4',
                           'Ch3']
        attachment.deleted = false
        attachment.user_id = 1..User::ROLE_NAMES.size

        attachment_counter += 1
        attachment.full_text = false
        attachment.is_url = false
      end

      item.attachments_count = attachment_counter
    end

    puts 'Uploading Files...'
    # Upload the actual files
    files = ['test/fixtures/test_pdf.pdf', 'test/fixtures/test_picture.jpg', 'test/fixtures/test_word.doc']
    Attachment.all.each do |a|
      a.file = File.open(files[(0..files.size - 1).to_a.sample])
      a.save!
    end

    puts 'Populating students...'
    Student.populate 440 do |student|
      student.first_name = Faker::Name.first_name
      student.last_name = Faker::Name.last_name
      student.email = "#{student.first_name}.#{student.last_name}@test.yorku.ca"
      student.username = "#{student.first_name[0]}#{student.last_name}"
      student.role = 'student'
      student.created_by_user_id = 1..2
      student.inactive = false
      student.role = User::STUDENT_USER

      StudentDetails.populate 1 do |sd|
        sd.student_number = 100_000_000..900_000_000
        sd.preferred_phone = 5_551_111_111..5_559_999_999
        sd.cds_counsellor = Faker::Name.name
        sd.cds_counsellor_email = Faker::Internet.email.to_s
        sd.student_id = student.id
        sd.transcription_coordinator_id = 1
        sd.transcription_assistant_id = 1
        sd.requires_orientation = true
        sd.orientation_completed = false
        sd.format_pdf = [true, false]
        sd.format_kurzweil = [true, false]
        sd.format_daisy = [true, false]
        sd.format_braille = [true, false]
        sd.format_word = [true, false]
        sd.format_large_print = [true, false]
        sd.format_other = %w[mp3 wave mov]

        sd.book_retrieval = [true, false]
        sd.accessibility_lab_access = [true, false]
        sd.alternate_format_required = true
      end

      Note.populate 1 do |note|
        note.student_id = student.id
        note.note = Populator.sentences(4..6)
        note.user_id = 1..2
      end
    end

    puts 'Assigning Items to Students'

    Student.all.each do |student|
      ItemConnection.populate 1..40 do |c|
        c.item_id = 1..Item.all.size
        c.student_id = student.id
        c.expires_on = 3.months.from_now
      end
    end

    puts 'Populating Terms and Courses'

    index = 0
    term_start = 1.days.ago
    term_end = 3.months.from_now
    Term.populate 6 do |term|
      index += 1
      # :name, :start_date, :end_date
      term.name = "Term #{index}"
      term.start_date = term_start
      term.end_date = term_end

      term_start = term_end
      term_end += 3.months

      term.courses_count = 0

      courses = %w[HIST MATH HUMA POLS ECON COMP ITEC NATS ARTS SOSC PSYC
                   EDUC SOCI MATH FEMS]
      codes = %w[1000 1010 1020 2000 2010 2020 2030 3000 3010 3020 4000 4010
                 4020 4030]
      Course.populate 30 do |course|
        # attr_accessible :title, :code
        course_num = (0..courses.size - 1).to_a.sample
        code_num = (0..codes.size - 1).to_a.sample

        # 2011_AP_HUMA_Y_1970__9_A
        course.title = "#{courses[course_num]} #{codes[code_num]}"
        course.code = "#{term.start_date.year}_AP_#{courses[course_num]}_Y_#{codes[code_num]}__6_A"
        course.term_id = term.id
        course.items_count = 0
      end
    end

    puts 'Assigning Items to Courses'

    Item.all.each do |item|
      ItemCourseConnection.populate 1..2 do |c|
        c.course_id = 1..Course.all.size
        c.item_id = item.id
      end
    end

    puts 'Creating acquisition requets'
    AcquisitionRequest.populate 50 do |ar|
      ar.item_id = 1..Item.all.size
      ar.requested_by_id = 1..User.not_students.size
      ar.acquisition_reason = 'Some reason'
      statuses = [AcquisitionRequest::STATUS_OPEN, AcquisitionRequest::STATUS_CANCELLED,
                  AcquisitionRequest::STATUS_ACQUIRED, AcquisitionRequest::STATUS_BACK_ORDERED]
      ar.status = statuses.sample
      ar.acquisition_notes = 'Some notes'

      if ar.status == AcquisitionRequest::STATUS_CANCELLED
        ar.cancelled_by_id = 1..User.not_students.size
        ar.cancellation_reason = 'Some cancellation Reason'
        ar.cancelled_at = Date.today
      end
      if ar.status == AcquisitionRequest::STATUS_ACQUIRED
        ar.acquired_by_id = 1..User.not_students.size
        ar.acquisition_source_type = PapyrusSettings.acquisition_sources.to_a.sample
        ar.acquisition_source_name = 'Some name'
        ar.acquired_at = Date.today
      end
      if ar.status == AcquisitionRequest::STATUS_BACK_ORDERED
        ar.back_ordered_until = 1.year.from_now
        ar.back_ordered_by_id = 1..User.not_students.size
      end
    end
  end
end
