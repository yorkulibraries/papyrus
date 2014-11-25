require 'test_helper'
require Rails.root.join("lib", "papyrus", "student_loader.rb")

class Papyrus::StudentLoaderTest < ActiveSupport::TestCase
  setup do
    @loader = Papyrus::StudentLoader.new
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
    s = create(:student, first_name: "Joe", last_name: "Schmoe")

    ENV["FIELDS_ORDER"] = ["student_number", "first_name", "last_name", "email", "cds_counsellor"].join(" ")
    sample_data = [
      ["111111", "jerome", "iron", "j@i.com", "Smitthy"],
      ["222222", "richard", "hammer", "r@h.com", "Smitthy"],
      [s.details.student_number, "Joseph", "Schmoesef", "jo@shmo.com", "Smitthy"]
    ]

    assert_difference "Student.count", 2 do
      # should create two new students
      result = @loader.from_list(sample_data)

      assert_equal 2, result[:created].size, "2 Created"
      assert_equal 1, result[:updated].size, "1 updated"
    end

    # should update existing student
    s.reload
    assert_equal "Joseph", s.first_name, "First name changed"
    assert_equal "Schmoesef", s.last_name, "Last name changed"
    assert_equal "jo@shmo.com", s.email, "Email name changed"

  end
end
