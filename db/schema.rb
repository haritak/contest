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

ActiveRecord::Schema[7.1].define(version: 2024_12_19_125521) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "education_directorates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_education_directorates_on_name", unique: true
  end

  create_table "generated_files", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "purpose"
    t.string "status"
    t.string "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_generated_files_on_user_id"
  end

  create_table "invitations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "student_id", null: false
    t.string "link", limit: 2048
    t.boolean "active"
    t.bigint "submission_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_invitations_on_student_id"
    t.index ["submission_type_id"], name: "index_invitations_on_submission_type_id"
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "invited_submissions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "submission_id"
    t.bigint "invitation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "student_submission_id"
    t.index ["invitation_id"], name: "index_invited_submissions_on_invitation_id"
    t.index ["student_submission_id"], name: "index_invited_submissions_on_student_submission_id"
    t.index ["submission_id"], name: "index_invited_submissions_on_submission_id"
  end

  create_table "people", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "father_name"
    t.string "mother_name"
    t.integer "gender"
    t.string "contact_phone"
    t.string "contact_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "school_classes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "school_class"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description", default: ""
    t.bigint "school_type_id"
    t.index ["school_type_id"], name: "index_school_classes_on_school_type_id"
  end

  create_table "school_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "school_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_type"], name: "index_school_types_on_school_type", unique: true
  end

  create_table "schools", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "contact_phone"
    t.string "contact_email"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "school_type_id", null: false
    t.bigint "education_directorate_id", null: false
    t.string "city"
    t.boolean "is_spedu", default: false
    t.index ["education_directorate_id"], name: "index_schools_on_education_directorate_id"
    t.index ["school_type_id"], name: "index_schools_on_school_type_id"
    t.index ["user_id"], name: "index_schools_on_user_id"
  end

  create_table "sent_emails", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "person_id"
    t.string "recipient_email", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_sent_emails_on_person_id"
    t.index ["user_id"], name: "index_sent_emails_on_user_id"
  end

  create_table "site_settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "site_name", null: false
    t.string "site_title", null: false
    t.boolean "allow_autonomous_submissions", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hide_students", default: false
    t.boolean "shut_down_previews", default: false
    t.boolean "enable_coadmin", default: false
    t.datetime "date_to_deactivate_seminar_participation"
    t.index ["site_name"], name: "index_site_settings_on_site_name", unique: true
  end

  create_table "specialities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "code", limit: 30
    t.string "description", limit: 200
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_specialities_on_code", unique: true
  end

  create_table "student_submission_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "accepted_filetype"
    t.integer "max_submissions"
    t.boolean "optional"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_submission_user_tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "student_submission_id", null: false
    t.bigint "user_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_submission_id"], name: "index_student_submission_user_tags_on_student_submission_id"
    t.index ["tag_id"], name: "index_student_submission_user_tags_on_tag_id"
    t.index ["user_id"], name: "index_student_submission_user_tags_on_user_id"
  end

  create_table "student_submissions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "student_submission_type_id", null: false
    t.string "title"
    t.text "notes"
    t.bigint "user_id", null: false
    t.boolean "finalized", default: false
    t.datetime "finalized_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "review_user_id"
    t.datetime "review_datetime"
    t.text "review_notes"
    t.boolean "review_public"
    t.boolean "review_marked_ok", default: false
    t.index ["review_user_id"], name: "fk_rails_8da25c4bd6"
    t.index ["student_id"], name: "index_student_submissions_on_student_id"
    t.index ["student_submission_type_id"], name: "index_student_submissions_on_student_submission_type_id"
    t.index ["user_id"], name: "index_student_submissions_on_user_id"
  end

  create_table "students", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "school_class_id", null: false
    t.boolean "is_adult", default: false
    t.string "guardian"
    t.boolean "finalized", default: false
    t.integer "mandatory_counter", default: 0
    t.integer "optional_counter", default: 0
    t.integer "finalized_counter", default: 0
    t.integer "reviews_counter", default: 0
    t.index ["person_id"], name: "index_students_on_person_id"
    t.index ["school_class_id"], name: "index_students_on_school_class_id"
  end

  create_table "submission_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "submission_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "optional", default: false
    t.string "accepted_filetype"
    t.text "description"
    t.integer "max_submissions", default: 1
  end

  create_table "submissions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "submission_description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "submission_type_id", null: false
    t.boolean "finalized", default: false
    t.datetime "finalized_date"
    t.bigint "person_id"
    t.boolean "reviewed", default: false
    t.text "reviewer_notes"
    t.index ["person_id"], name: "index_submissions_on_person_id"
    t.index ["submission_type_id"], name: "index_submissions_on_submission_type_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "user_id", null: false
    t.string "color"
    t.boolean "is_global"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "teachers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "speciality_id"
    t.integer "team_role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "finalized"
    t.datetime "finalized_date"
    t.boolean "gdpr_accepted", default: false
    t.boolean "coadmin", default: false
    t.index ["person_id"], name: "index_teachers_on_person_id"
    t.index ["speciality_id"], name: "index_teachers_on_speciality_id"
  end

  create_table "teams", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nickname"
    t.bigint "school_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "finalized", default: false
    t.datetime "finalized_date"
    t.string "contact_phone"
    t.string "contact_email"
    t.boolean "participation_finalized", default: false
    t.datetime "participation_finalized_date"
    t.boolean "seminar_participation_finalized", default: false
    t.datetime "seminar_participation_finalized_date"
    t.boolean "school_approved", default: false
    t.string "school_approval_secret"
    t.index ["school_id"], name: "index_teams_on_school_id"
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email"
    t.string "username", limit: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.boolean "is_admin"
    t.boolean "is_secretary", default: false
    t.boolean "is_reviewer", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "generated_files", "users"
  add_foreign_key "invitations", "students"
  add_foreign_key "invitations", "submission_types"
  add_foreign_key "invitations", "users"
  add_foreign_key "invited_submissions", "invitations"
  add_foreign_key "invited_submissions", "student_submissions"
  add_foreign_key "invited_submissions", "submissions"
  add_foreign_key "people", "users"
  add_foreign_key "school_classes", "school_types"
  add_foreign_key "schools", "education_directorates"
  add_foreign_key "schools", "school_types"
  add_foreign_key "schools", "users"
  add_foreign_key "sent_emails", "people"
  add_foreign_key "sent_emails", "users"
  add_foreign_key "student_submission_user_tags", "student_submissions"
  add_foreign_key "student_submission_user_tags", "tags"
  add_foreign_key "student_submission_user_tags", "users"
  add_foreign_key "student_submissions", "student_submission_types"
  add_foreign_key "student_submissions", "students"
  add_foreign_key "student_submissions", "users"
  add_foreign_key "student_submissions", "users", column: "review_user_id"
  add_foreign_key "students", "people"
  add_foreign_key "students", "school_classes"
  add_foreign_key "submissions", "people"
  add_foreign_key "submissions", "submission_types"
  add_foreign_key "submissions", "users"
  add_foreign_key "tags", "users"
  add_foreign_key "teachers", "people"
  add_foreign_key "teachers", "specialities"
  add_foreign_key "teams", "schools"
  add_foreign_key "teams", "users"
end
