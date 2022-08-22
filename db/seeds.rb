# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

if Rails.env != 'test' and User.all.count == 0
  User.create!([
                 { username: 'admin', last_name: 'User', role: 'admin', inactive: false, type: nil, email: 'admin@me.ca',
                   created_by_user_id: nil, email_sent_at: nil, blocked: false, last_logged_in_at: '2022-05-25 14:32:52', first_name: 'Admin', last_active_at: '2022-05-25 14:32:52', first_time_login: true },
                 { username: 'cordinator', last_name: 'User', role: 'coordinator', inactive: false, type: nil,
                   email: 'coordinator@me.ca', created_by_user_id: nil, email_sent_at: nil, blocked: false, last_logged_in_at: nil, first_name: 'Coordinator', last_active_at: nil, first_time_login: true }
               ])
  Student.create!([
                    { username: 'student', last_name: 'User', role: 'student', inactive: false, type: 'Student', email: 'student@me.ca',
                      created_by_user_id: 1, email_sent_at: nil, blocked: false, last_logged_in_at: nil, first_name: 'student', last_active_at: nil, first_time_login: true }
                  ])
  StudentDetails.create!([
                           { student_id: 3, student_number: 3_333_333, preferred_phone: '33333333', cds_counsellor: '', format_pdf: true,
                             format_kurzweil: false, format_daisy: false, format_braille: false, format_note: '', transcription_coordinator_id: 2, request_form_signed_on: nil, transcription_assistant_id: 2, format_word: false, format_large_print: false, requires_orientation: true, orientation_completed: false, orientation_completed_at: nil, book_retrieval: false, accessibility_lab_access: false, cds_counsellor_email: 'counsellor@me.ca', alternate_format_required: true, format_other: false, format_epub: false }
                         ])
end
