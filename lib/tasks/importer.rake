require 'ostruct'
require 'csv'
require Rails.root.join("lib", "papyrus", "student_loader.rb")

namespace :import do
  desc "Papyrus Import Tasks"

  task :students => :environment do
    students = Array.new

    if ENV["HELP"]
      puts "Usage: rake import:students [ < file_path | FILE=file_path ]"

      loader = Papyrus::StudentLoader.new
      puts "Optional ENV variables: #{loader.get_env_options_names}\n"      
      exit
    end

    report "--------- Begin #{Time.now.strftime("%Y-%m-%d %H:%M:%S")} ---------"

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

    report "Updated: #{status[:updated].count}"
    report "Created: #{status[:created].count}"

    if status[:errors].count > 0
      report "Errors: #{status[:errors].count}"
      status[:errors].each do |e|
        report "ERROR: #{e}"
      end
    end

    if ENV["send_welcome_email"]
      report "Welcome Emails:  #{status[:created].count}"
    end

    total_processed = status[:updated].count + status[:created].count
    total_active_students = Student.active.count

    report "--------- End #{Time.now.strftime("%Y-%m-%d %H:%M:%S")} ---------"

  end


    # Crude logging
  def report(string)
    if ENV['REPORT'] != nil
      puts "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} --- #{string}"
    end
  end


end
