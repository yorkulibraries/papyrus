namespace :utils do
  desc "Papyrus Utilities Tasks"
  task :deactivate_students => :environment do
    students = Student.active.where("last_logged_in_at > ? OR last_logged_in_at IS ?", 1.year.ago, nil)
    students.each do |s|
      s.inactive = true
      s.save(validate: false)
    end

    puts "Dectivated #{students.size} students"
  end

  task :block_lab_only_students => :environment do
    students = Student.lab_access_only
    students.each do |s|
      s.blocked = true
      s.save(validate: false)
    end

    puts "Blocked #{students.size} lab only students"
  end
end
