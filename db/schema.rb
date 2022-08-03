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

ActiveRecord::Schema[7.0].define(version: 2022_08_03_160659) do
  create_table "action_text_rich_texts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_admin_comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

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

  create_table "attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "attached_by_id", null: false
    t.string "approval_status", limit: 10
    t.bigint "approved_by_id"
    t.bigint "company_id", null: false
    t.bigint "project_id", null: false
    t.bigint "phase_id", null: false
    t.bigint "step_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visible_to_client", default: false
    t.integer "position"
    t.index ["approved_by_id"], name: "index_attachments_on_approved_by_id"
    t.index ["attached_by_id"], name: "index_attachments_on_attached_by_id"
    t.index ["company_id"], name: "index_attachments_on_company_id"
    t.index ["phase_id"], name: "index_attachments_on_phase_id"
    t.index ["project_id"], name: "index_attachments_on_project_id"
    t.index ["step_id"], name: "index_attachments_on_step_id"
  end

  create_table "clients", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "first_name", limit: 30
    t.string "last_name", limit: 30
    t.string "email"
    t.string "phone", limit: 20
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_type", limit: 15
    t.text "address"
    t.index ["company_id"], name: "index_clients_on_company_id"
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "companies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "logo_url"
    t.boolean "active", default: true
    t.string "company_type", limit: 15
    t.integer "created_by"
    t.datetime "deleted_at"
    t.integer "parent_company_id"
    t.string "currency", limit: 10
    t.string "units", limit: 15
    t.date "trial_end_date"
    t.boolean "trial", default: false
    t.text "address"
    t.string "gst_number", limit: 25
    t.text "entity_names"
    t.index ["deleted_at"], name: "index_companies_on_deleted_at"
    t.index ["name"], name: "index_companies_on_name", unique: true
    t.index ["parent_company_id"], name: "index_companies_on_parent_company_id"
  end

  create_table "daily_activities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.bigint "step_id", null: false
    t.text "details"
    t.string "status", limit: 15
    t.decimal "cost_cents", precision: 20, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "on_date"
    t.string "title"
    t.index ["company_id"], name: "index_daily_activities_on_company_id"
    t.index ["project_id"], name: "index_daily_activities_on_project_id"
    t.index ["step_id"], name: "index_daily_activities_on_step_id"
    t.index ["user_id"], name: "index_daily_activities_on_user_id"
  end

  create_table "exception_tracks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "body", size: :medium
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "impressions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "impressionable_type"
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name"
    t.string "action_name"
    t.string "view_name"
    t.string "request_hash"
    t.string "ip_address"
    t.string "session_hash"
    t.text "message"
    t.text "referrer"
    t.text "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index", length: { params: 255 }
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", length: { message: 255 }
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "materials", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "category", limit: 40
    t.string "item", limit: 50
    t.string "material", limit: 50
    t.text "description"
    t.integer "quantity", default: 0
    t.decimal "unit_cost_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "cost_cents", precision: 20, scale: 2, default: "0.0"
    t.date "required_by_date"
    t.integer "reminder_days_before"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_materials_on_company_id"
    t.index ["owner_type", "owner_id"], name: "index_materials_on_owner"
    t.index ["project_id"], name: "index_materials_on_project_id"
    t.index ["user_id"], name: "index_materials_on_user_id"
  end

  create_table "notes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.integer "owner_id"
    t.string "owner_type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_notes_on_company_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "payments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "plan", limit: 30
    t.decimal "discount", precision: 10, scale: 2, default: "0.0"
    t.string "reference_number"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "phase_id"
    t.bigint "project_id", null: false
    t.decimal "amount_cents", precision: 20, scale: 2, default: "0.0"
    t.string "status", limit: 50
    t.date "due_date"
    t.date "received_on"
    t.index ["company_id"], name: "index_payments_on_company_id"
    t.index ["deleted_at"], name: "index_payments_on_deleted_at"
    t.index ["phase_id"], name: "index_payments_on_phase_id"
    t.index ["project_id"], name: "index_payments_on_project_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "phases", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.string "status", limit: 20
    t.bigint "project_id", null: false
    t.bigint "company_id", null: false
    t.bigint "assigned_to_id", null: false
    t.boolean "visible_to_client", default: false
    t.string "payment_status", limit: 20
    t.integer "percentage_complete", default: 0
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_days", default: 0
    t.integer "completed_days", default: 0
    t.boolean "payment_required", default: false
    t.decimal "payment_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.integer "days", default: 0
    t.integer "payment_due_percentage", default: 0
    t.decimal "payment_due_cents", precision: 20, scale: 2, default: "0.0"
    t.integer "position"
    t.index ["assigned_to_id"], name: "index_phases_on_assigned_to_id"
    t.index ["company_id"], name: "index_phases_on_company_id"
    t.index ["project_id"], name: "index_phases_on_project_id"
  end

  create_table "project_accesses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.string "role_name", limit: 20
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "permissions"
    t.index ["company_id"], name: "index_project_accesses_on_company_id"
    t.index ["project_id"], name: "index_project_accesses_on_project_id"
    t.index ["user_id"], name: "index_project_accesses_on_user_id"
  end

  create_table "projects", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.decimal "cost_estimate_cents", precision: 20
    t.integer "percentage_completed", default: 0
    t.string "status", limit: 20
    t.bigint "company_id", null: false
    t.bigint "client_id"
    t.bigint "team_lead_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "currency", limit: 5
    t.integer "total_days", default: 0
    t.integer "completed_days", default: 0
    t.decimal "payment_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.integer "cloned_from"
    t.decimal "client_estimated_budget_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "actual_cost_cents", precision: 20, scale: 2, default: "0.0"
    t.integer "estimated_builtup_area", default: 0
    t.integer "actual_builtup_area", default: 0
    t.decimal "fees_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "percentage_of_estimated_budget", precision: 5, scale: 2, default: "0.0"
    t.decimal "per_sq_ft_rate_cents", precision: 10, scale: 2, default: "0.0"
    t.string "fee_type", limit: 20
    t.string "project_type", limit: 30
    t.string "scale", limit: 20
    t.string "style", limit: 30
    t.string "pattern", limit: 30
    t.text "services"
    t.text "address"
    t.decimal "discount", precision: 5, scale: 2, default: "0.0"
    t.string "entity_name", limit: 100
    t.index ["client_id"], name: "index_projects_on_client_id"
    t.index ["company_id"], name: "index_projects_on_company_id"
    t.index ["team_lead_id"], name: "index_projects_on_team_lead_id"
  end

  create_table "quotes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "user_id", null: false
    t.bigint "client_id", null: false
    t.string "project_type", limit: 30
    t.string "scale", limit: 20
    t.string "style", limit: 30
    t.string "pattern", limit: 30
    t.text "services"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_quotes_on_client_id"
    t.index ["company_id"], name: "index_quotes_on_company_id"
    t.index ["user_id"], name: "index_quotes_on_user_id"
  end

  create_table "roles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "site_visits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "company_id", null: false
    t.bigint "phase_id", null: false
    t.decimal "cost_cents", precision: 20, scale: 2, default: "0.0"
    t.date "scheduled_on"
    t.date "conducted_on"
    t.bigint "assigned_to_id", null: false
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_site_visits_on_assigned_to_id"
    t.index ["company_id"], name: "index_site_visits_on_company_id"
    t.index ["phase_id"], name: "index_site_visits_on_phase_id"
    t.index ["project_id"], name: "index_site_visits_on_project_id"
  end

  create_table "steps", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.string "status", limit: 20
    t.bigint "project_id", null: false
    t.bigint "phase_id", null: false
    t.bigint "assigned_to_id", null: false
    t.boolean "visible_to_client", default: false
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", null: false
    t.integer "days", default: 0
    t.string "approval_status", limit: 10, default: "N/A"
    t.integer "position"
    t.decimal "cost_cents", precision: 20, scale: 2, default: "0.0"
    t.index ["assigned_to_id"], name: "index_steps_on_assigned_to_id"
    t.index ["company_id"], name: "index_steps_on_company_id"
    t.index ["phase_id"], name: "index_steps_on_phase_id"
    t.index ["project_id"], name: "index_steps_on_project_id"
  end

  create_table "taggings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", collation: "utf8mb3_bin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "phone", limit: 20
    t.boolean "active", default: true
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "company_id"
    t.datetime "deleted_at"
    t.boolean "system_created", default: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.boolean "accept_terms", default: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "versions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false, :limit=>191}"
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "attachments", "companies"
  add_foreign_key "attachments", "phases"
  add_foreign_key "attachments", "projects"
  add_foreign_key "attachments", "steps"
  add_foreign_key "attachments", "users", column: "approved_by_id"
  add_foreign_key "attachments", "users", column: "attached_by_id"
  add_foreign_key "clients", "companies"
  add_foreign_key "clients", "users"
  add_foreign_key "daily_activities", "companies"
  add_foreign_key "daily_activities", "projects"
  add_foreign_key "daily_activities", "steps"
  add_foreign_key "daily_activities", "users"
  add_foreign_key "materials", "companies"
  add_foreign_key "materials", "projects"
  add_foreign_key "materials", "users"
  add_foreign_key "notes", "companies"
  add_foreign_key "notes", "users"
  add_foreign_key "payments", "companies"
  add_foreign_key "payments", "phases"
  add_foreign_key "payments", "projects"
  add_foreign_key "payments", "users"
  add_foreign_key "phases", "companies"
  add_foreign_key "phases", "projects"
  add_foreign_key "phases", "users", column: "assigned_to_id"
  add_foreign_key "project_accesses", "companies"
  add_foreign_key "project_accesses", "projects"
  add_foreign_key "project_accesses", "users"
  add_foreign_key "projects", "companies"
  add_foreign_key "projects", "users", column: "client_id"
  add_foreign_key "projects", "users", column: "team_lead_id"
  add_foreign_key "quotes", "clients"
  add_foreign_key "quotes", "companies"
  add_foreign_key "quotes", "users"
  add_foreign_key "site_visits", "companies"
  add_foreign_key "site_visits", "phases"
  add_foreign_key "site_visits", "projects"
  add_foreign_key "site_visits", "users", column: "assigned_to_id"
  add_foreign_key "steps", "companies"
  add_foreign_key "steps", "phases"
  add_foreign_key "steps", "projects"
  add_foreign_key "steps", "users", column: "assigned_to_id"
  add_foreign_key "taggings", "tags"
end
