namespace :utils do
  desc "Papyrus Utilities Tasks"
  task :deactivate_inactive_students => :environment do
    students = Student.active.where(last_logged_in_at: 1.year.ago)
    students.each do |s|
      student.inactive = true
      student.save(validate: false)
    end

    puts "Dectivated #{students.size} students"   
  end
end
