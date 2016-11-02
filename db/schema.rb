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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161102190012) do

  create_table "access_codes", force: :cascade do |t|
    t.string   "for"
    t.string   "code"
    t.date     "expires_at"
    t.integer  "student_id"
    t.integer  "created_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "shared",        default: false
  end

  create_table "acquisition_requests", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "requested_by_id"
    t.text     "acquisition_reason"
    t.string   "status"
    t.integer  "cancelled_by_id"
    t.text     "cancellation_reason"
    t.datetime "cancelled_at"
    t.integer  "acquired_by_id"
    t.datetime "acquired_at"
    t.text     "acquisition_notes"
    t.text     "acquisition_source_type"
    t.text     "acquisition_source_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "back_ordered_note"
    t.string   "note"
    t.date     "back_ordered_until"
    t.string   "back_ordered_reason"
    t.integer  "back_ordered_by_id"
  end

  create_table "announcements", force: :cascade do |t|
    t.text     "message"
    t.string   "audience"
    t.boolean  "active",     default: false
    t.integer  "user_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appointments", force: :cascade do |t|
    t.integer  "student_id"
    t.string   "title"
    t.integer  "user_id"
    t.datetime "at"
    t.text     "note"
    t.boolean  "completed",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "name"
    t.integer  "item_id"
    t.string   "file"
    t.boolean  "full_text",            default: false
    t.boolean  "deleted",              default: false
    t.integer  "user_id",              default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_url",               default: false
    t.string   "url"
    t.boolean  "access_code_required", default: false
  end

  add_index "attachments", ["item_id", "deleted"], name: "index_attachments_on_item_id_and_deleted"

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
    t.string   "request_uuid"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index"
  add_index "audits", ["created_at"], name: "index_audits_on_created_at"
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid"
  add_index "audits", ["user_id", "user_type"], name: "user_index"

  create_table "courses", force: :cascade do |t|
    t.string   "title"
    t.string   "code"
    t.integer  "term_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "items_count", default: 0, null: false
    t.integer  "syllabus_id"
  end

  add_index "courses", ["term_id"], name: "index_courses_on_term_id"

  create_table "documents", force: :cascade do |t|
    t.string   "name"
    t.string   "attachment"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.integer  "user_id",         default: 0
    t.boolean  "deleted",         default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "item_connections", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "student_id"
    t.date     "expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_connections", ["expires_on", "item_id"], name: "ic_e_i_index"
  add_index "item_connections", ["expires_on", "student_id"], name: "ic_e_s_index"
  add_index "item_connections", ["student_id", "item_id", "expires_on"], name: "ic_s_i_e_index"

  create_table "item_course_connections", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_course_connections", ["course_id", "item_id"], name: "icc_c_i_index"

  create_table "items", force: :cascade do |t|
    t.string   "title"
    t.string   "unique_id"
    t.string   "item_type"
    t.string   "callnumber"
    t.string   "author"
    t.integer  "user_id",              default: 0
    t.string   "isbn"
    t.string   "published_date"
    t.string   "publisher"
    t.string   "edition"
    t.string   "physical_description"
    t.string   "language_note"
    t.string   "source"
    t.string   "source_note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attachments_count",    default: 0, null: false
  end

  add_index "items", ["unique_id"], name: "index_items_on_unique_id"
  add_index "items", ["user_id"], name: "index_items_on_user_id"

  create_table "notes", force: :cascade do |t|
    t.text     "note"
    t.integer  "student_id"
    t.integer  "user_id",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["student_id"], name: "index_notes_on_student_id"

  create_table "scan_items", force: :cascade do |t|
    t.string   "summary"
    t.integer  "item_id"
    t.integer  "scan_list_id"
    t.integer  "assigned_to_id"
    t.integer  "created_by_id"
    t.date     "due_date"
    t.string   "status"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "scan_lists", force: :cascade do |t|
    t.string   "name"
    t.integer  "created_by_id"
    t.integer  "assigned_to_id"
    t.string   "status"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true

  create_table "student_courses", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_details", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "student_number"
    t.string   "preferred_phone"
    t.string   "cds_counsellor"
    t.boolean  "format_pdf"
    t.boolean  "format_kurzweil"
    t.boolean  "format_daisy"
    t.boolean  "format_braille"
    t.boolean  "format_word"
    t.boolean  "format_large_print"
    t.text     "format_note"
    t.integer  "transcription_coordinator_id"
    t.integer  "transcription_assistant_id"
    t.date     "request_form_signed_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "requires_orientation",         default: true,  null: false
    t.boolean  "orientation_completed",        default: false, null: false
    t.date     "orientation_completed_at"
    t.boolean  "book_retrieval",               default: false
    t.boolean  "accessibility_lab_access",     default: false
    t.string   "cds_counsellor_email"
    t.boolean  "alternate_format_required",    default: true
    t.boolean  "format_other"
  end

  add_index "student_details", ["student_id"], name: "index_student_details_on_student_id"
  add_index "student_details", ["transcription_assistant_id"], name: "ta_id"
  add_index "student_details", ["transcription_coordinator_id"], name: "tc_id"

  create_table "students", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "username"
    t.string   "student_number"
    t.integer  "user_id",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terms", force: :cascade do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "courses_count", default: 0, null: false
  end

  add_index "terms", ["end_date"], name: "index_terms_on_end_date"

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "last_name"
    t.string   "role"
    t.boolean  "inactive",           default: false
    t.string   "type"
    t.string   "email"
    t.integer  "created_by_user_id"
    t.datetime "email_sent_at"
    t.boolean  "blocked",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_logged_in_at"
    t.string   "first_name"
    t.datetime "last_active_at"
  end

  add_index "users", ["inactive", "role"], name: "index_users_on_inactive_and_role"
  add_index "users", ["inactive"], name: "index_users_on_inactive"
  add_index "users", ["type", "inactive"], name: "index_users_on_type_and_inactive"
  add_index "users", ["username"], name: "index_users_on_username"

  create_table "work_history", force: :cascade do |t|
    t.string   "object_type"
    t.integer  "object_id"
    t.string   "comment"
    t.integer  "user_id",     default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "work_history", ["user_id"], name: "u_w_h_index"

end
