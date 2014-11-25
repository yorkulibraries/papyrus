require 'ostruct'
require 'csv'
require Rails.root.join("lib", "papyrus", "student_loader.rb")

ACTIVATION_THRESHOLD = ENV["ACTIVATION_THRESHOLD"].to_i || 100

namespace :import do
  desc "Papyrus Import Tasks"

  task :students => :environment do
    students = Array.new

    if ENV["FILE"]
      report "Importing form File #{ENV["FILE"]}"

      File.open(ENV["FILE"], "r").each_line do |line|
        data = CSV.parse(line).first
        students.push data
      end
    else
      report "Importing Students from STDIN"

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
      report "sending welcome meail to #{status[:created].count} students"
    end

    total_processed = status[:updated].count + status[:created].count
    total_active_students = Student.active.count

    if (total_processed - total_active_students).abs < ACTIVATION_THRESHOLD
      report "Deactivating all students first"
      # deactivate all
      Student.active.update_all(inactive: true)

      report "Activating #{total_processed} processed students"
      # Activating processed
      Student.where("id in (?)", status[:updated] + status[:created]).update_all(inactive: false)

      report "Done."
    else
      report "We're trying to activate/deactivate too many students at once. Manual activation/deactivaton required. Or up the ACTIVATION_THRESHOLD"
    end


  end



    # Crude logging
  def report(string)
    if ENV['REPORT'] != nil
      puts string
    end
  end


end
