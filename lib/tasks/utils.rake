namespace :utils do
  desc "Papyrus Utilities Tasks"
  task :deactivate_students => :environment do
    active_students = Student.active.where("last_logged_in_at < ?", 1.year.ago)
    active_students.each do |s|
      s.inactive = true
      s.audit_comment = "Deactivating inactive students..."
      s.save(validate: false)
    end

    lab_access_only_students = Student.lab_access_only
    lab_access_only_students.each do |s|
      s.inactive = true
      s.audit_comment = "Deactivating Lab Access Only students...."
      s.save(validate: false)
    end

    puts "Dectivated #{active_students.size} inactive students and #{lab_access_only_students.size} lab only students"
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
