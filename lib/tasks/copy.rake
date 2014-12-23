
namespace :copy do
  desc "Papyrus Copying Tasks"

  task :student_number_to_username => :environment do
    students = Student.all

    students.each do |s|
      s.update_attribute(:username, s.details.student_number)
    end

    puts "Copied #{students.size} student numbers"
  end
end
