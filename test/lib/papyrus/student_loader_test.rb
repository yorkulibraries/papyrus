require 'test_helper'
require Rails.root.join("lib", "papyrus", "student_loader.rb")

class Papyrus::StudentLoaderTest < ActiveSupport::TestCase
  setup do
    @loader = Papyrus::StudentLoader.new
    PapyrusSettings.import_auto_assign_coordinator = PapyrusSettings::FALSE
    PapyrusSettings.import_send_welcome_email_to_student = PapyrusSettings::FALSE
    PapyrusSettings.import_notify_coordinator = PapyrusSettings::FALSE
  end

  should "only accept an array" do
    assert_nil @loader.from_list(nil), "should be nil"
    assert_nil @loader.from_list("something"), "should be array of students"
  end

  should "process options properly, via ENV or argument" do
    opt = { created_by_id: 2 }

    # test via argument
    options = @loader.process_options(opt)

    assert_equal 2, options[:created_by_id], "Created by id was updated"
    assert_equal Papyrus::StudentLoader::DEFAULT_OPTIONS[:ignore_first_line], options[:ignore_first_line], "Ignore first line is still Default"


    # test via ENV
    ENV["COORDINATOR_ID"]="3"

    options = @loader.process_options(nil)

    assert_equal 3, options[:coordinator_id].to_i, "Coordinator id was updated"
    assert_equal Papyrus::StudentLoader::DEFAULT_OPTIONS[:ignore_first_line], options[:ignore_first_line], "Ignore first line is still Default"

  end


  should "import students from csv data" do
    c = create(:user, id: 1) # coordinator user, for testing mysql referential checks
    s = create(:student, first_name: "Joe", last_name: "Schmoe")

    ENV["FIELDS_ORDER"] = ["student_number", "first_name", "last_name", "email", "cds_counsellor"].join(" ")

    sample_data = [
      ["ignore", "first", "line", "by", "default"],
      ["111111", "jerome", "iron", "j@i.com", "Smitthy"],
      ["222222", "richard", "hammer", "r@h.com", "Smitthy"],
      [s.details.student_number, "Joseph", "Schmoesef", "jo@shmo.com", "Smitthy"]
    ]

    assert_difference "Student.count", 2 do
      # should create two new students
      result = @loader.from_list(sample_data)

      assert_equal 2, result[:created].size, "2 Created, #{result[:errors]}"
      assert_equal 1, result[:updated].size, "1 updated"
    end

    # should update existing student
    s.reload
    assert_equal "Joseph", s.first_name, "First name changed"
    assert_equal "Schmoesef", s.last_name, "Last name changed"
    assert_equal "jo@shmo.com", s.email, "Email name changed"

  end

  should "auto assign coordinator id form the list, in ordered manner" do
    c1 = create(:user, role: User::COORDINATOR)
    c2 = create(:user, role: User::COORDINATOR)

    sample_data = [
      ["ignore", "first", "line", "by", "default"],
      ["111111", "jerome", "iron", "j@i.com", "Smitthy"],
      ["222222", "richard", "hammer", "r@h.com", "Smitthy"],
      ["333333", "Joseph", "Schmoesef", "jo@shmo.com", "Smitthy"]
    ]

    PapyrusSettings.import_auto_assign_coordinator = PapyrusSettings::TRUE
    @loader.from_list(sample_data)

    students = Student.all.to_ary
    assert_equal c1.id, students.at(0).details.transcription_coordinator.id, "Should be first coordinator"
    assert_equal c2.id, students.at(1).details.transcription_coordinator.id, "Should be second coordinator"
    assert_equal c1.id, students.at(2).details.transcription_coordinator.id, "Should be first coordinator"

  end

  should "not assign coordinaor first, if it was last assigned" do
    c1 = create(:user, role: User::COORDINATOR)
    c2 = create(:user, role: User::COORDINATOR)

    details = create(:student_details, transcription_coordinator_id: c1.id)
    student = create(:student, student_details: details)

    sample_data = [
      ["ignore", "first", "line", "by", "default"],
      ["111111", "jerome", "iron", "j@i.com", "Smitthy"],
      ["222222", "richard", "hammer", "r@h.com", "Smitthy"],
      ["333333", "Joseph", "Schmoesef", "jo@shmo.com", "Smitthy"]
    ]

    PapyrusSettings.import_auto_assign_coordinator = PapyrusSettings::TRUE
    @loader.from_list(sample_data)

    students = Student.all.to_ary
    assert_equal c1.id, students.at(0).details.transcription_coordinator.id, "Should be first coordinator"
    assert_equal c2.id, students.at(1).details.transcription_coordinator.id, "Should be second coordinator"
    assert_equal c1.id, students.at(2).details.transcription_coordinator.id, "Should be first coordinator"
    assert_equal c2.id, students.at(3).details.transcription_coordinator.id, "Should be second coordinator"
  end

  should "send an welcome email to student upon creation if setting is enabled" do
    c1 = create(:user, role: User::COORDINATOR)

    sample_data = [
      ["ignore", "first", "line", "by", "default"],
      ["111111", "jerome", "iron", "j@i.com", "Smitthy"],
      ["222222", "richard", "hammer", "r@h.com", "Smitthy"],
      ["333333", "Joseph", "Schmoesef", "jo@shmo.com", "Smitthy"]
    ]

    ActionMailer::Base.deliveries = []

    PapyrusSettings.import_send_welcome_email_to_student = PapyrusSettings::TRUE
    PapyrusSettings.email_allow = PapyrusSettings::TRUE
    assert ActionMailer::Base.deliveries.empty?, "nothing in the queue"

    perform_enqueued_jobs do
      @loader.from_list(sample_data,{ coordinator_id: c1.id })
      assert_equal 3, ActionMailer::Base.deliveries.size, "3 emails  in the queue, #{PapyrusSettings.import_send_welcome_email_to_student}"
    end

  end

  should "send an notification email to coordinator upon creation if setting is enabled" do
    c1 = create(:user, role: User::COORDINATOR)

    sample_data = [
      ["ignore", "first", "line", "by", "default"],
      ["111111", "jerome", "iron", "j@i.com", "Smitthy"],
      ["222222", "richard", "hammer", "r@h.com", "Smitthy"],
      ["333333", "Joseph", "Schmoesef", "jo@shmo.com", "Smitthy"]
    ]

    ActionMailer::Base.deliveries = []

    PapyrusSettings.import_notify_coordinator = PapyrusSettings::TRUE
    PapyrusSettings.email_allow = PapyrusSettings::TRUE


    perform_enqueued_jobs do
      assert ActionMailer::Base.deliveries.empty?, "nothing in the queue"

      @loader.from_list(sample_data,{ coordinator_id: c1.id })

      assert_equal 3, ActionMailer::Base.deliveries.size, "3 emails  in the queue, #{PapyrusSettings.import_notify_coordinator}"
    end

  end

end
