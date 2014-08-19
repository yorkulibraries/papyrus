# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140819181859) do

  create_table "access_codes", :force => true do |t|
    t.string   "for"
    t.string   "code"
    t.date     "expires_at"
    t.integer  "student_id"
    t.integer  "created_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "acquisition_requests", :force => true do |t|
    t.integer  "item_id"
    t.integer  "requested_by_id"
    t.date     "requested_by_date"
    t.integer  "fulfilled_by_id"
    t.date     "fulfilled_by_date"
    t.boolean  "fulfilled",         :default => false
    t.boolean  "cancelled",         :default => false
    t.integer  "cancelled_by_id"
    t.date     "cancelled_by_date"
    t.text     "notes"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "acquisition_requests", ["item_id"], :name => "index_acquisition_requests_on_item_id"

  create_table "attachments", :force => true do |t|
    t.string   "name"
    t.integer  "item_id"
    t.string   "file"
    t.boolean  "full_text",            :default => false
    t.boolean  "deleted",              :default => false
    t.integer  "user_id",              :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.boolean  "is_url",               :default => false
    t.string   "url"
    t.boolean  "access_code_required", :default => false
  end

  add_index "attachments", ["item_id", "deleted"], :name => "index_attachments_on_item_id_and_deleted"

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "courses", :force => true do |t|
    t.string   "title"
    t.string   "code"
    t.integer  "term_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "items_count", :default => 0, :null => false
  end

  add_index "courses", ["term_id"], :name => "index_courses_on_term_id"

  create_table "item_connections", :force => true do |t|
    t.integer  "item_id"
    t.integer  "student_id"
    t.date     "expires_on"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "item_connections", ["expires_on", "item_id"], :name => "index_item_connections_on_expires_on_and_item_id"
  add_index "item_connections", ["expires_on", "student_id"], :name => "index_item_connections_on_expires_on_and_student_id"
  add_index "item_connections", ["student_id", "item_id", "expires_on"], :name => "index_item_connections_on_student_id_and_item_id_and_expires_on"

  create_table "item_course_connections", :force => true do |t|
    t.integer  "item_id"
    t.integer  "course_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "item_course_connections", ["course_id", "item_id"], :name => "index_item_course_connections_on_course_id_and_item_id"

  create_table "items", :force => true do |t|
    t.string   "title"
    t.string   "unique_id"
    t.string   "item_type"
    t.string   "callnumber"
    t.string   "author"
    t.integer  "user_id",              :default => 0
    t.string   "isbn"
    t.string   "published_date"
    t.string   "publisher"
    t.string   "edition"
    t.string   "physical_description"
    t.string   "language_note"
    t.string   "source"
    t.string   "source_note"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "attachments_count",    :default => 0, :null => false
  end

  create_table "notes", :force => true do |t|
    t.text     "note"
    t.integer  "student_id"
    t.integer  "user_id",    :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "notes", ["student_id"], :name => "index_notes_on_student_id"

  create_table "student_details", :force => true do |t|
    t.integer  "student_id"
    t.integer  "student_number"
    t.string   "home_phone"
    t.string   "campus_phone"
    t.string   "cell_phone"
    t.string   "work_phone"
    t.boolean  "di_ld"
    t.boolean  "di_low_vision"
    t.boolean  "di_blind"
    t.boolean  "di_braille_labels_required"
    t.boolean  "di_head_injury"
    t.boolean  "di_partially_sighted"
    t.boolean  "di_other"
    t.text     "di_note"
    t.boolean  "sp_psmds"
    t.boolean  "sp_lds"
    t.boolean  "sp_mhds"
    t.boolean  "sp_glendon_counselling"
    t.string   "cds_adviser"
    t.boolean  "format_pdf"
    t.boolean  "format_kurzweil"
    t.boolean  "format_daisy"
    t.boolean  "format_braille"
    t.boolean  "format_word"
    t.boolean  "format_large_print"
    t.text     "pf_note"
    t.string   "wrms_ref_number"
    t.integer  "transcription_coordinator_id",        :limit => 255
    t.integer  "transcription_assistant_id"
    t.date     "request_form_signed_on"
    t.date     "intake_appointment_on"
    t.date     "responsibilities_document_signed_on"
    t.date     "ppy_access_granted_on"
    t.date     "adaptive_computed_access_granted_on"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.boolean  "requires_orientation",                               :default => true,  :null => false
    t.boolean  "orientation_completed",                              :default => false, :null => false
    t.date     "orientation_completed_at"
  end

  add_index "student_details", ["student_id"], :name => "index_student_details_on_student_id"
  add_index "student_details", ["transcription_assistant_id"], :name => "index_student_details_on_transcription_assistant_id"
  add_index "student_details", ["transcription_coordinator_id"], :name => "index_student_details_on_transcription_coordinator_id"

  create_table "students", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "username"
    t.string   "student_number"
    t.integer  "user_id",        :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "notes_count",    :default => 0, :null => false
  end

  create_table "terms", :force => true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "courses_count", :default => 0, :null => false
  end

  add_index "terms", ["end_date"], :name => "index_terms_on_end_date"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "name"
    t.string   "role"
    t.boolean  "inactive",           :default => false
    t.string   "type"
    t.string   "email"
    t.integer  "created_by_user_id"
    t.datetime "email_sent_at"
    t.boolean  "blocked",            :default => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.datetime "last_logged_in_at"
  end

  add_index "users", ["inactive", "role"], :name => "index_users_on_inactive_and_role"
  add_index "users", ["inactive"], :name => "index_users_on_inactive"
  add_index "users", ["type", "inactive"], :name => "index_users_on_type_and_inactive"
  add_index "users", ["username"], :name => "index_users_on_username"

end
