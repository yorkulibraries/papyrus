require 'ostruct'
require 'csv'
require Rails.root.join("lib", "papyrus", "student_loader.rb")

namespace :import do
  desc "Papyrus Import Tasks"

  task :students => :environment do
    students = Array.new

    if ENV["FILE"]
      log "Importing form File #{ENV["FILE"]}"
      File.open("my/file/path", "r").each_line do |line|
        data = CSV.parse(line).first
        students.push data
      end
    else
      log "Importing Students from STDIN"

      STDIN.each_line do |line|
        data = CSV.parse(line).first
        students.push data
      end
    end

    loader = Papyrus::StudentLoader.new
    stats = loader.from_csv(students)

    log "Updated: #{stats[:updated].count}"
    log "Created: #{stats[:created].count}"
  end



    # Crude logging
  def log(string)
    if ENV['DEBUG'] != nil
      puts string
    end
  end

end
