require 'ostruct'
require 'csv'
require Rails.root.join("lib", "papyrus", "student_loader.rb")


#### IMPORTER TEST LINE
# bundle exec rake import:students COORDINATOR_ID=1 REPORT=true CREATOR_ID=1 EMAIL_REPORT_LOG_TO=test@paypurs.com FILE=test/fixtures/test_student_import_latest.csv
# File No Erros: test_student_import_latest.csv
# File With Erros: test_student_import_latest_erros.csv
#######

namespace :import do
  desc "Papyrus Import Tasks"

  @report_log = Array.new

  task :students => :environment do
    students = Array.new

    if ENV["HELP"]
      puts "Usage: rake import:students [ < file_path | FILE=file_path ]"
      puts "Optional: SEND_WELCOME_EMAIL=id of user used to send this email."
      puts "Optional: REPORT=true print out import report."
      puts "Optional: EMAIL_REPORT_LOG_TO=email address where to email the report"

      loader = Papyrus::StudentLoader.new
      puts "Optional ENV variables: #{loader.get_env_options_names}\n"
      exit
    end

    report "\n\n--------- Begin #{Time.now.strftime("%Y-%m-%d %H:%M:%S")} ---------\n\n"

    if ENV["FILE"]
      report "Import: #{ENV["FILE"]}"

      File.open(ENV["FILE"], "r").each_line do |line|
        data = CSV.parse(line).first
        students.push data
      end
    else
      report "Import: STDIN"

      STDIN.each_line do |line|
        data = CSV.parse(line).first
        students.push data
      end
    end

    loader = Papyrus::StudentLoader.new
    status = loader.from_list(students)

    report "-----------"
    if status[:errors].count > 0
      report "Errors: #{status[:errors].count}"
      status[:errors].each do |e|
        report "<<<<<< IMPORT ERROR >>>>>>>"        
        report "#{e.first.join(" | ")}"
        e.last.each_pair { |k,v|
          report  "ERROR: #{k} -- #{v.join(" and ")}"
        }
        report "<<<<<<>>>>>>>"
      end
      report "-----------"
    end

    report "Updated: #{status[:updated].count}"
    status[:updated].each do |id|
      student = Student.find(id)
      report "Updated: #{student.name} [#{student.details.student_number}]"
    end
    report "-----------"

    report "Created: #{status[:created].count}"
    status[:created].each do |id|
      student = Student.find(id)
      report "Created: #{student.name} [#{student.details.student_number}]"
    end

    report "-----------"


    if ENV["SEND_WELCOME_EMAIL"]
      sender = User.find(ENV["SEND_WELCOME_EMAIL"]) # send_welcome email should be id of the sender user.

      status[:created].each do |id|

        student = Student.find(id)
        StudentMailer.welcome_email(student, sender).deliver_later
        report "Mail sent to #{student.name} by #{sender.name}"
      end

      report "Welcome Emails:  #{status[:created].count}"
    end

    total_processed = status[:updated].count + status[:created].count
    total_active_students = Student.active.count

    report "\n\n--------- End #{Time.now.strftime("%Y-%m-%d %H:%M:%S")} ---------"


    if ENV["EMAIL_REPORT_LOG_TO"]
      subject = "Papyrus Student Import Report"
      subject << "- IMPORT ERRORS" if status[:errors].count > 0
      ReportMailer.mail_report(ENV["EMAIL_REPORT_LOG_TO"], @report_log.join("\n"), subject).deliver
    end

  end


    # Crude logging
  def report(string)
    @report_log << "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} --- #{string}"

    if ENV['REPORT'] != nil
      puts "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} --- #{string}"
    end
  end


end
