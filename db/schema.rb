# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_06_30_182701) do
  create_table "access_codes", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "for"
    t.string "code"
    t.date "expires_at"
    t.integer "student_id"
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "shared", default: false
  end

  create_table "acquisition_requests", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "item_id"
    t.integer "requested_by_id"
    t.text "acquisition_reason"
    t.string "status"
    t.integer "cancelled_by_id"
    t.text "cancellation_reason"
    t.datetime "cancelled_at"
    t.integer "acquired_by_id"
    t.datetime "acquired_at"
    t.text "acquisition_notes"
    t.text "acquisition_source_type"
    t.text "acquisition_source_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "note"
    t.date "back_ordered_until"
    t.string "back_ordered_reason"
    t.integer "back_ordered_by_id"
  end

  create_table "announcements", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.text "message", size: :medium
    t.string "audience"
    t.boolean "active", default: false
    t.integer "user_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "appointments", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "student_id"
    t.string "title"
    t.integer "user_id"
    t.datetime "at"
    t.text "note"
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attachments", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.integer "item_id"
    t.string "file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "deleted", default: false
    t.integer "user_id", default: 0
    t.boolean "full_text", default: false
    t.boolean "is_url", default: false
    t.string "url"
    t.boolean "access_code_required", default: false
    t.index ["item_id", "deleted"], name: "index_attachments_on_item_id_and_deleted"
  end

  create_table "audits", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes", size: :medium
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.datetime "created_at"
    t.string "request_uuid"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "courses", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.string "code"
    t.integer "term_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "items_count", default: 0, null: false
    t.integer "syllabus_id"
    t.index ["term_id"], name: "index_courses_on_term_id"
  end

  create_table "documents", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.integer "attachable_id"
    t.string "attachable_type"
    t.integer "user_id", default: 0
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_connections", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "item_id"
    t.integer "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "expires_on"
    t.index ["expires_on", "item_id"], name: "ic_e_i_index"
    t.index ["expires_on", "item_id"], name: "index_item_connections_on_expires_on_and_item_id"
    t.index ["expires_on", "student_id"], name: "ic_e_s_index"
    t.index ["expires_on", "student_id"], name: "index_item_connections_on_expires_on_and_student_id"
    t.index ["student_id", "item_id", "expires_on"], name: "ic_s_i_e_index"
  end

  create_table "item_course_connections", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "item_id"
    t.integer "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["course_id", "item_id"], name: "icc_c_i_index"
  end

  create_table "items", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.string "unique_id"
    t.string "item_type"
    t.string "callnumber"
    t.string "author"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id", default: 0
    t.string "isbn"
    t.string "published_date"
    t.string "publisher"
    t.string "edition"
    t.string "physical_description"
    t.string "language_note"
    t.string "source"
    t.string "source_note"
    t.integer "attachments_count", default: 0, null: false
    t.integer "updated_by"
    t.string "course_code"
    t.index ["created_at"], name: "index_items_on_created_at"
    t.index ["title"], name: "index_items_on_title"
  end

  create_table "notes", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.text "note", size: :medium
    t.integer "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id", default: 0
    t.index ["student_id"], name: "index_notes_on_student_id"
  end

  create_table "scan_items", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "summary"
    t.integer "item_id"
    t.integer "scan_list_id"
    t.integer "assigned_to_id"
    t.integer "created_by_id"
    t.date "due_date"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scan_lists", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.integer "created_by_id"
    t.integer "assigned_to_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "student_courses", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "student_id"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_details", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "student_id"
    t.integer "student_number"
    t.string "preferred_phone"
    t.string "cds_counsellor"
    t.boolean "format_pdf"
    t.boolean "format_kurzweil"
    t.boolean "format_daisy"
    t.boolean "format_braille"
    t.text "format_note", size: :medium
    t.integer "transcription_coordinator_id"
    t.date "request_form_signed_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "transcription_assistant_id"
    t.boolean "format_word"
    t.boolean "format_large_print"
    t.boolean "requires_orientation", default: true, null: false
    t.boolean "orientation_completed", default: false, null: false
    t.date "orientation_completed_at"
    t.boolean "book_retrieval", default: false
    t.boolean "accessibility_lab_access", default: false
    t.string "cds_counsellor_email"
    t.boolean "alternate_format_required", default: true
    t.boolean "format_other"
    t.boolean "format_epub"
    t.index ["transcription_assistant_id"], name: "ta_id"
    t.index ["transcription_assistant_id"], name: "transcription_assistant_index"
    t.index ["transcription_coordinator_id", "transcription_assistant_id"], name: "transcription_user_ids"
    t.index ["transcription_coordinator_id"], name: "tc_id"
    t.index ["transcription_coordinator_id"], name: "transcription_coordinator_index"
  end

  create_table "students", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "student_number"
    t.integer "user_id", default: 0
    t.integer "notes_count", default: 0, null: false
    t.string "encrypted_password"
  end

  create_table "terms", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "courses_count", default: 0, null: false
    t.index ["end_date"], name: "index_terms_on_end_date"
  end

  create_table "todo_items", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "summary"
    t.integer "item_id"
    t.integer "todo_list_id"
    t.integer "assigned_to_id"
    t.integer "created_by_id"
    t.date "due_date"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "todo_lists", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "created_by_id"
    t.integer "assigned_to_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "username"
    t.string "last_name"
    t.string "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "inactive", default: false
    t.string "type"
    t.string "email"
    t.integer "created_by_user_id"
    t.datetime "email_sent_at"
    t.boolean "blocked", default: false
    t.datetime "last_logged_in_at"
    t.string "first_name"
    t.datetime "last_active_at"
    t.boolean "first_time_login", default: true
    t.string "encrypted_password"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["inactive", "role"], name: "index_users_on_inactive_and_role"
    t.index ["inactive", "type"], name: "active_users_by_type"
    t.index ["inactive"], name: "active_users"
  end

end
