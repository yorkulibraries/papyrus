namespace :db do
    desc "Papyrus Related Tasks"
   
    
    task :populate => :environment do 
          require 'populator'
          require 'faker'

          [Item, Attachment, Student, StudentDetails, ItemConnection, Note, User, Term, Course, ItemCourseConnection].each(&:delete_all)
          
          puts "Create all user accounts"
          
          index = 0

          User.populate User::ROLE_NAMES.size do |user|
            user.username = User::ROLE_NAMES[index]
            user.name = "#{User::ROLE_NAMES[index].titleize} User"
            user.inactive = false
            user.role = User::ROLE_NAMES[index]
            index = index + 1
            
            if user.role == User::STUDENT_USER
                user.type = "Student"
                user.created_by_user_id = 1
            end  
          end 
                              
          
          puts "Generating Items and Files"
          
          Item.populate 50..100 do |item|
            item.title = Populator.words(4..6).titleize
            item.unique_id = 1000..100000
            item.user_id = 1..User::ROLE_NAMES.size
            
            item.item_type = ["book", "article", "course_kit"]
            item.callnumber = "GH 457 1981 AB"
            item.author = Faker::Name.name
            
            Attachment.populate 1..4 do |attachment|
              attachment.item_id = item.id
              attachment.name = ["Chapter 1", "Chapter 2", "Chapter 3", "Chapter 4", "Chapter 5", "Ch1", "Ch2", "Ch4", "Ch3"]
              attachment.deleted = false
              attachment.user_id = 1..User::ROLE_NAMES.size
            end
            
          end
          
          puts "Uploading Files..."
          # Upload the actual files 
          files = ["test/test_pdf.pdf", "test/test_picture.jpg", "test/test_word.doc"]          
          Attachment.all.each do |a|            
            a.file = File.open(files[(0..files.size-1).to_a.sample])
            a.save!
          end
          
          puts "Populating students..."
          Student.populate 40 do |student|
            student.name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
            student.email = Faker::Internet.email
            student.username = Faker::Internet.user_name            
            student.created_by_user_id = 1..2
            student.inactive = false         
            
            StudentDetails.populate 1 do |sd|
        				sd.student_number = 10000..100000
        				sd.cell_phone = 333..444
        				sd.cds_adviser = Faker::Name.name
        				sd.student_id = student.id
        				sd.transcription_coordinator_id = 1..5
            end
            
            Note.populate 2..4 do |note|
              note.student_id = student.id
              note.note = Populator.sentences(4..6)
              note.user_id = 1..2
            end
          end
                    
          puts "Assigning Items to Students"
          
          Student.all.each do |student|
              ItemConnection.populate 1..40 do |c|                
                c.item_id = 1..Item.all.size
                c.student_id = student.id
                c.expires_on = 3.months.from_now
              end
          end
            
          
          puts "Populating Terms and Courses"  
            
          index = 0
          term_start = 1.days.ago
          term_end = 3.months.from_now
          Term.populate 6 do |term|
              index = index + 1
              #:name, :start_date, :end_date
              term.name = "Term #{index}"
              term.start_date = term_start
              term.end_date = term_end
              
              term_start = term_end
              term_end = term_end + 3.months
              
              
              courses = ["HIST", "MATH", "HUMA", "POLS", "ECON", "COMP", "ITEC", "NATS", "ARTS", "SOSC", "PSYC", "EDUC"]
              codes = ["1000", "1010", "1020", "2000", "2010", "2020", "2030", "3000", "3010", "3020", "4000", "4010", "4020", "4030"]
              Course.populate 30 do |course|
                # attr_accessible :title, :code
                course_num = (0..courses.size-1).to_a.sample
                code_num =  (0..codes.size-1).to_a.sample
                
                # 2011_AP_HUMA_Y_1970__9_A
                course.title = "#{courses[course_num]} #{codes[code_num]}"
                course.code = "#{term.start_date.year}_AP_#{courses[course_num]}_Y_#{codes[code_num]}__6_A"
                course.term_id = term.id
              end  
              
          end
          
           puts "Assigning Items to Courses"

           Item.all.each do |item|
               ItemCourseConnection.populate 1..2 do |c|                
                 c.course_id = 1..Course.all.size
                 c.item_id = item.id                  
               end
           end
          
    end
    
    
   
end