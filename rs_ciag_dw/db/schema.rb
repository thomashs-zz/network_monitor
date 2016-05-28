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

ActiveRecord::Schema.define(version: 20160522004009) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "accident_investigations", force: :cascade do |t|
    t.integer  "treatment_id",                            null: false
    t.integer  "company_contact_id",                      null: false
    t.string   "event_type",                  limit: 255, null: false
    t.date     "away_starts_at"
    t.date     "away_ends_at"
    t.string   "accident_classification",     limit: 255
    t.date     "report_date"
    t.text     "accident_origin"
    t.boolean  "using_equipment"
    t.text     "using_equipment_description"
    t.text     "lesion_agent"
    t.integer  "hours_till_accident"
    t.text     "accident_description"
    t.text     "witnesses"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "accident_investigations", ["treatment_id"], name: "index_accident_investigations_on_treatment_id", using: :btree

  create_table "accident_treatments", force: :cascade do |t|
    t.integer  "treatment_id",                                 null: false
    t.text     "origin_of_injury"
    t.boolean  "send_to_inss",                 default: false, null: false
    t.text     "body_matrix"
    t.string   "period_away",      limit: 255,                 null: false
    t.string   "away_type",        limit: 255,                 null: false
    t.text     "obs"
    t.datetime "in_at",                                        null: false
    t.datetime "out_at",                                       null: false
    t.boolean  "to_rest",                      default: false, null: false
    t.integer  "created_by_id",                                null: false
    t.integer  "updated_by_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.text     "to_rest_obs"
  end

  add_index "accident_treatments", ["treatment_id"], name: "index_accident_treatments_on_treatment_id", using: :btree

  create_table "appointment_bulk_create_times", force: :cascade do |t|
    t.integer "appointment_bulk_create_id"
    t.time    "starts_at"
    t.integer "duration_in_minutes"
  end

  create_table "appointment_bulk_creates", force: :cascade do |t|
    t.string   "bulk_create_type",       limit: 255
    t.integer  "month"
    t.integer  "year"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "duration_in_minutes"
    t.text     "shift_collision_solver"
    t.string   "appointment_type",       limit: 255
    t.integer  "company_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "log_count"
    t.text     "log_exception"
    t.text     "log_errors"
    t.datetime "queue_starts_at"
    t.datetime "queue_ends_at"
  end

  create_table "appointment_cancels", force: :cascade do |t|
    t.integer  "appointment_id"
    t.integer  "company_id"
    t.integer  "employee_company_id"
    t.text     "reason"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.text     "other_reason"
  end

  create_table "appointment_credits", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "shift_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "quantity"
    t.string   "appointment_type", limit: 255
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "appointment_credits", ["company_id", "shift_id", "year", "month", "appointment_type"], name: "appointment_credits_unique_constraint", unique: true, using: :btree
  add_index "appointment_credits", ["company_id"], name: "index_appointment_credits_on_company_id", using: :btree
  add_index "appointment_credits", ["shift_id"], name: "index_appointment_credits_on_shift_id", using: :btree

  create_table "appointment_excepts", force: :cascade do |t|
    t.string   "description",   limit: 255
    t.string   "except_type",   limit: 255
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.date     "except_date"
  end

  create_table "appointments", force: :cascade do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "employee_company_id"
    t.integer  "company_id"
    t.string   "appointment_type",            limit: 255
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "occupational_reason",         limit: 255
    t.integer  "shift_id"
    t.string   "new_employee_name",           limit: 255
    t.string   "new_employee_cpf",            limit: 255
    t.date     "new_employee_birth_date"
    t.string   "new_employee_activity",       limit: 255
    t.string   "new_employee_role",           limit: 255
    t.string   "new_employee_post",           limit: 255
    t.string   "new_employee_sector",         limit: 255
    t.string   "new_employee_phone",          limit: 255
    t.string   "new_employee_gender",         limit: 255
    t.integer  "new_employee_shift_id"
    t.date     "new_employee_admission_date"
    t.string   "new_employee_registration",   limit: 255
    t.string   "update_employee_sector",      limit: 255
    t.string   "update_employee_role",        limit: 255
    t.string   "update_employee_post",        limit: 255
    t.string   "update_employee_activity",    limit: 255
    t.boolean  "is_new_employee",                         default: false
    t.text     "obs"
  end

  add_index "appointments", ["company_id"], name: "index_appointments_on_company_id", using: :btree
  add_index "appointments", ["employee_company_id"], name: "index_appointments_on_employee_company_id", using: :btree

  create_table "audiometries", force: :cascade do |t|
    t.integer  "treatment_id",                                   null: false
    t.datetime "in_at"
    t.datetime "out_at"
    t.string   "audiometry_type",    limit: 255
    t.string   "status",             limit: 255
    t.integer  "a_left_250"
    t.integer  "a_left_500"
    t.integer  "a_left_1000"
    t.integer  "a_left_2000"
    t.integer  "a_left_3000"
    t.integer  "a_left_4000"
    t.integer  "a_left_6000"
    t.integer  "a_left_8000"
    t.integer  "a_right_250"
    t.integer  "a_right_500"
    t.integer  "a_right_1000"
    t.integer  "a_right_2000"
    t.integer  "a_right_3000"
    t.integer  "a_right_4000"
    t.integer  "a_right_6000"
    t.integer  "a_right_8000"
    t.integer  "o_left_250"
    t.integer  "o_left_500"
    t.integer  "o_left_1000"
    t.integer  "o_left_2000"
    t.integer  "o_left_3000"
    t.integer  "o_left_4000"
    t.integer  "o_right_250"
    t.integer  "o_right_500"
    t.integer  "o_right_1000"
    t.integer  "o_right_2000"
    t.integer  "o_right_3000"
    t.integer  "o_right_4000"
    t.integer  "created_by_id",                                  null: false
    t.integer  "updated_by_id"
    t.text     "obs"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.boolean  "is_reference",                   default: false
    t.integer  "worsed_compared_to"
    t.text     "id_hash"
  end

  add_index "audiometries", ["treatment_id"], name: "index_audiometries_on_treatment_id", using: :btree

  create_table "audiometry_result_trackings", force: :cascade do |t|
    t.integer  "original"
    t.integer  "current"
    t.text     "obs"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "cid10s", force: :cascade do |t|
    t.string   "group",       limit: 255, null: false
    t.string   "code",        limit: 255, null: false
    t.string   "description", limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "clinical_emergency_treatments", force: :cascade do |t|
    t.integer  "treatment_id",                  null: false
    t.text     "obs"
    t.boolean  "to_rest",       default: false, null: false
    t.boolean  "send_to_inss"
    t.integer  "created_by_id",                 null: false
    t.integer  "updated_by_id"
    t.datetime "in_at",                         null: false
    t.datetime "out_at",                        null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "to_rest_obs"
  end

  add_index "clinical_emergency_treatments", ["treatment_id"], name: "index_clinical_emergency_treatments_on_treatment_id", using: :btree

  create_table "clinical_treatments", force: :cascade do |t|
    t.integer  "treatment_id",                       null: false
    t.text     "body_matrix"
    t.boolean  "not_occupational",   default: false, null: false
    t.boolean  "clinical_relevance",                 null: false
    t.boolean  "solved",                             null: false
    t.boolean  "send_to_inss",       default: false, null: false
    t.boolean  "to_rest",            default: false, null: false
    t.datetime "in_at",                              null: false
    t.datetime "out_at",                             null: false
    t.text     "obs"
    t.integer  "created_by_id",                      null: false
    t.integer  "updated_by_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.text     "to_rest_obs"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",                          limit: 255,                     null: false
    t.string   "cnpj",                          limit: 255,                     null: false
    t.string   "company_type",                  limit: 255,                     null: false
    t.integer  "created_by_id",                                                 null: false
    t.integer  "updated_by_id"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.string   "color",                         limit: 255, default: "#000000"
    t.text     "appointments_percentage"
    t.decimal  "total_appointments_percentage"
  end

  add_index "companies", ["cnpj"], name: "index_companies_on_cnpj", unique: true, using: :btree

  create_table "company_contacts", force: :cascade do |t|
    t.text     "id_hash"
    t.integer  "company_id"
    t.string   "name",                                       limit: 255,                 null: false
    t.string   "email",                                      limit: 255,                 null: false
    t.boolean  "can_receive_emergency_notifications",                    default: false, null: false
    t.boolean  "can_receive_accidents_notifications",                    default: false, null: false
    t.boolean  "can_receive_occupational_notifications",                 default: false, null: false
    t.integer  "created_by_id",                                                          null: false
    t.integer  "updated_by_id"
    t.datetime "created_at",                                                             null: false
    t.datetime "updated_at",                                                             null: false
    t.boolean  "can_receive_audiometry_worst_alert",                     default: false
    t.boolean  "can_receive_complementary_exams_expiration",             default: false
  end

  create_table "complete_report_queues", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.text     "options"
    t.text     "companies"
    t.datetime "worker_started_at"
    t.datetime "worker_ended_at"
    t.string   "filename",           limit: 255
    t.boolean  "has_error"
    t.text     "exception_message"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "employee_companies"
  end

  add_index "complete_report_queues", ["user_id"], name: "index_complete_report_queues_on_user_id", using: :btree

  create_table "crms", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "dw_dim_accident_treatments_temp", id: false, force: :cascade do |t|
    t.integer "accident_treatment_id"
    t.string  "origin_of_injury",      limit: 255
    t.string  "body_matrix",           limit: 255
    t.string  "period_away",           limit: 255
    t.string  "away_type",             limit: 255
  end

  create_table "dw_dim_occupational_treatments_temp", id: false, force: :cascade do |t|
    t.integer "occupational_treatment_id"
    t.string  "type",                         limit: 255
    t.string  "is_able",                      limit: 255
    t.string  "osteomuscular_complaint",      limit: 255
    t.string  "osteomuscular_complaint_side", limit: 255
  end

  create_table "dw_other_treatment_exams_tags_temp", id: false, force: :cascade do |t|
    t.integer "treatment_id"
    t.integer "tag_id"
  end

  create_table "emergency_infos", force: :cascade do |t|
    t.integer  "treatment_id",                           null: false
    t.datetime "ocurred_at",                             null: false
    t.boolean  "is_holiday",                             null: false
    t.string   "accident_site",              limit: 255
    t.string   "accident_site_other",        limit: 255
    t.string   "shift_leader",               limit: 255
    t.boolean  "transported"
    t.string   "destiny",                    limit: 255
    t.string   "destiny_other",              limit: 255
    t.datetime "destiny_arrival_at"
    t.string   "destiny_responsible",        limit: 255
    t.string   "transportation_responsible", limit: 255
    t.string   "transportation_type",        limit: 255
    t.string   "transportation_type_other",  limit: 255
    t.datetime "transportation_left_at"
    t.integer  "local_ok_user_id"
    t.datetime "local_ok_at"
    t.text     "local_ok_obs"
    t.integer  "local_ok_ambulance_user_id"
    t.datetime "local_ok_ambulance_at"
    t.text     "local_ok_ambulance_obs"
    t.integer  "created_by_id",                          null: false
    t.integer  "updated_by_id"
    t.text     "obs"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "emergency_infos", ["treatment_id"], name: "index_emergency_infos_on_treatment_id", using: :btree

  create_table "employee_companies", force: :cascade do |t|
    t.integer  "employee_id",                               null: false
    t.integer  "company_id",                                null: false
    t.string   "registration",   limit: 255,                null: false
    t.string   "contract_type",  limit: 255,                null: false
    t.boolean  "active",                     default: true, null: false
    t.date     "admission_date",                            null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "shift_id"
  end

  add_index "employee_companies", ["company_id"], name: "index_employee_companies_on_company_id", using: :btree
  add_index "employee_companies", ["employee_id"], name: "index_employee_companies_on_employee_id", using: :btree

  create_table "employees", force: :cascade do |t|
    t.string   "name",          limit: 255, null: false
    t.string   "cpf",           limit: 255, null: false
    t.date     "birth_date",                null: false
    t.string   "post",          limit: 255
    t.string   "activity",      limit: 255
    t.string   "role",          limit: 255
    t.string   "phone",         limit: 255
    t.integer  "created_by_id",             null: false
    t.integer  "updated_by_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "gender",        limit: 255
    t.text     "heads_up"
    t.string   "sector",        limit: 255
  end

  create_table "external_medical_certificate_items", force: :cascade do |t|
    t.integer  "external_medical_certificate_id"
    t.integer  "cid10_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "doctor_name",                     limit: 255
    t.string   "doctor_crm",                      limit: 255
    t.text     "obs"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "external_medical_certificate_items", ["cid10_id"], name: "index_external_medical_certificate_items_on_cid10_id", using: :btree

  create_table "external_medical_certificates", force: :cascade do |t|
    t.integer  "treatment_id"
    t.integer  "employee_company_id"
    t.integer  "created_by_id",       null: false
    t.integer  "updated_by_id"
    t.boolean  "send_to_inss",        null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "external_medical_certificates", ["employee_company_id"], name: "emc_employee_company_id", using: :btree
  add_index "external_medical_certificates", ["treatment_id"], name: "index_external_medical_certificates_on_treatment_id", using: :btree

  create_table "external_reports", force: :cascade do |t|
    t.integer  "employee_id"
    t.integer  "audiometry_id"
    t.integer  "spirometry_id"
    t.integer  "visiotest_id"
    t.text     "obs"
    t.text     "attachment"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.date     "external_report_date"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "external_reports", ["audiometry_id"], name: "index_external_reports_on_audiometry_id", using: :btree
  add_index "external_reports", ["employee_id"], name: "index_external_reports_on_employee_id", using: :btree
  add_index "external_reports", ["spirometry_id"], name: "index_external_reports_on_spirometry_id", using: :btree
  add_index "external_reports", ["visiotest_id"], name: "index_external_reports_on_visiotest_id", using: :btree

  create_table "nursing_doctors", force: :cascade do |t|
    t.integer  "treatment_id"
    t.datetime "in_at"
    t.datetime "out_at"
    t.text     "obs"
    t.integer  "created_by_id"
    t.integer  "update_by_id"
    t.boolean  "to_rest"
    t.boolean  "send_to_inss"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "to_rest_obs"
  end

  add_index "nursing_doctors", ["treatment_id"], name: "index_nursing_doctors_on_treatment_id", using: :btree

  create_table "nursings", force: :cascade do |t|
    t.integer  "treatment_id"
    t.text     "obs"
    t.datetime "in_at"
    t.datetime "out_at"
    t.boolean  "go_to_doctor"
    t.integer  "created_by_id"
    t.integer  "update_by_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "occupational_treatments", force: :cascade do |t|
    t.integer  "treatment_id",                                        null: false
    t.string   "reason",                  limit: 255,                 null: false
    t.text     "body_matrix"
    t.boolean  "able",                                default: true,  null: false
    t.boolean  "send_to_inss",                        default: false, null: false
    t.boolean  "to_rest",                             default: false, null: false
    t.text     "obs"
    t.datetime "in_at",                                               null: false
    t.datetime "out_at",                                              null: false
    t.integer  "created_by_id",                                       null: false
    t.integer  "updated_by_id"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.text     "to_rest_obs"
    t.boolean  "send_email_notification"
  end

  create_table "report_queries", force: :cascade do |t|
    t.integer  "report_id"
    t.string   "title",       limit: 255
    t.string   "subtitle",    limit: 255
    t.text     "query"
    t.string   "report_type", limit: 255
    t.integer  "relevance"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "report_queries", ["report_id"], name: "index_report_queries_on_report_id", using: :btree

  create_table "reports", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "relevance"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "screenings", force: :cascade do |t|
    t.integer  "treatment_id",      null: false
    t.integer  "pa_sistolica",      null: false
    t.integer  "pa_diastolica",     null: false
    t.decimal  "temperature",       null: false
    t.integer  "heart_rate",        null: false
    t.integer  "respiratory_rate",  null: false
    t.integer  "oxygen_saturation", null: false
    t.integer  "screening_level",   null: false
    t.datetime "in_at",             null: false
    t.datetime "out_at",            null: false
    t.integer  "created_by_id",     null: false
    t.integer  "updated_by_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "screenings", ["treatment_id"], name: "index_screenings_on_treatment_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "var",        limit: 255, null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "shifts", force: :cascade do |t|
    t.string   "description",      limit: 255
    t.integer  "starts_at_hour"
    t.integer  "starts_at_minute"
    t.integer  "ends_at_hour"
    t.integer  "ends_at_minute"
    t.boolean  "monday"
    t.boolean  "tuesday"
    t.boolean  "wednesday"
    t.boolean  "thursday"
    t.boolean  "friday"
    t.boolean  "saturday"
    t.boolean  "sunday"
    t.boolean  "for_appointments"
    t.integer  "relevance"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "spirometries", force: :cascade do |t|
    t.integer  "treatment_id",              null: false
    t.string   "status",        limit: 255
    t.text     "obs"
    t.string   "attachment",    limit: 255
    t.datetime "in_at"
    t.datetime "out_at"
    t.integer  "created_by_id",             null: false
    t.integer  "updated_by_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "spirometries", ["treatment_id"], name: "index_spirometries_on_treatment_id", using: :btree

  create_table "treatment_cid10s", force: :cascade do |t|
    t.integer  "clinical_treatment_id"
    t.integer  "occupational_treatment_id"
    t.integer  "clinical_emergency_treatment_id"
    t.integer  "accident_treatment_id"
    t.integer  "cid10_id",                        null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "nursing_doctor_id"
  end

  add_index "treatment_cid10s", ["accident_treatment_id"], name: "index_treatment_cid10s_on_accident_treatment_id", using: :btree
  add_index "treatment_cid10s", ["cid10_id"], name: "index_treatment_cid10s_on_cid10_id", using: :btree
  add_index "treatment_cid10s", ["clinical_emergency_treatment_id"], name: "index_treatment_cid10s_on_clinical_emergency_treatment_id", using: :btree
  add_index "treatment_cid10s", ["clinical_treatment_id"], name: "index_treatment_cid10s_on_clinical_treatment_id", using: :btree
  add_index "treatment_cid10s", ["occupational_treatment_id"], name: "index_treatment_cid10s_on_occupational_treatment_id", using: :btree

  create_table "treatment_medical_certificates", force: :cascade do |t|
    t.integer  "clinical_treatment_id"
    t.integer  "occupational_treatment_id"
    t.integer  "clinical_emergency_treatment_id"
    t.integer  "accident_treatment_id"
    t.integer  "cid10_id",                        null: false
    t.date     "in_at",                           null: false
    t.date     "out_at",                          null: false
    t.text     "obs"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "nursing_doctor_id"
  end

  add_index "treatment_medical_certificates", ["accident_treatment_id"], name: "index_treatment_medical_certificates_on_accident_treatment_id", using: :btree
  add_index "treatment_medical_certificates", ["cid10_id"], name: "index_treatment_medical_certificates_on_cid10_id", using: :btree
  add_index "treatment_medical_certificates", ["clinical_emergency_treatment_id"], name: "tmc_clinical_emergency_id", using: :btree
  add_index "treatment_medical_certificates", ["clinical_treatment_id"], name: "index_treatment_medical_certificates_on_clinical_treatment_id", using: :btree
  add_index "treatment_medical_certificates", ["occupational_treatment_id"], name: "tmc_occupational_treatment_id", using: :btree

  create_table "treatment_rests", force: :cascade do |t|
    t.integer  "treatment_id",     null: false
    t.datetime "start_at",         null: false
    t.datetime "end_at",           null: false
    t.text     "obs"
    t.integer  "created_by_id",    null: false
    t.integer  "updated_by_id"
    t.boolean  "return_to_doctor", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "treatment_rests", ["treatment_id"], name: "index_treatment_rests_on_treatment_id", using: :btree

  create_table "treatments", force: :cascade do |t|
    t.text     "id_hash"
    t.integer  "employee_company_id",                       null: false
    t.datetime "in_at",                                     null: false
    t.datetime "out_at"
    t.string   "treatment_type",                limit: 255, null: false
    t.text     "reason"
    t.integer  "created_by_id",                             null: false
    t.integer  "updated_by_id"
    t.integer  "locker_id"
    t.boolean  "do_spirometry"
    t.boolean  "do_visiotest"
    t.boolean  "do_audiometry"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.text     "other_exams"
    t.boolean  "extra"
    t.integer  "appointment_id"
    t.string   "change_occupational_reason_to", limit: 255
  end

  add_index "treatments", ["employee_company_id"], name: "index_treatments_on_employee_company_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "failed_attempts",                    default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.string   "name",                   limit: 255,              null: false
    t.string   "user_type",              limit: 255,              null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.text     "companies_allowed"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "visiotests", force: :cascade do |t|
    t.integer  "treatment_id",                              null: false
    t.date     "last_exam"
    t.boolean  "use_lenses"
    t.text     "use_lenses_args"
    t.text     "obs"
    t.integer  "far_acuity_left_eye"
    t.integer  "far_acuity_right_eye"
    t.integer  "far_binocular_acuity"
    t.text     "far_binocular_acuity_matrix"
    t.boolean  "far_duochrome_green"
    t.boolean  "far_duochrome_red"
    t.string   "far_phoria",                    limit: 255
    t.text     "far_color_vision"
    t.integer  "close_acuity_left_eye"
    t.integer  "close_acuity_right_eye"
    t.integer  "close_binocular_acuity"
    t.text     "close_binocular_acuity_matrix"
    t.boolean  "close_duochrome_green"
    t.boolean  "close_duochrome_red"
    t.string   "close_phoria",                  limit: 255
    t.text     "close_color_vision"
    t.string   "status",                        limit: 255
    t.datetime "in_at"
    t.datetime "out_at"
    t.integer  "created_by_id",                             null: false
    t.integer  "updated_by_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_foreign_key "accident_investigations", "company_contacts", name: "accident_investigations_company_contact_id_fk"
  add_foreign_key "accident_investigations", "treatments", name: "accident_investigations_treatment_id_fk"
  add_foreign_key "accident_treatments", "treatments", name: "accident_treatments_treatment_id_fk"
  add_foreign_key "accident_treatments", "users", column: "created_by_id", name: "accident_treatments_created_by_id_fk"
  add_foreign_key "accident_treatments", "users", column: "updated_by_id", name: "accident_treatments_updated_by_id_fk"
  add_foreign_key "appointment_cancels", "appointments", name: "appointment_cancels_appointment_id_fk"
  add_foreign_key "appointment_cancels", "companies", name: "appointment_cancels_company_id_fk"
  add_foreign_key "appointment_cancels", "employee_companies", name: "appointment_cancels_employee_company_id_fk"
  add_foreign_key "appointment_cancels", "users", column: "created_by_id", name: "appointment_cancels_created_by_id_fk"
  add_foreign_key "appointment_cancels", "users", column: "updated_by_id", name: "appointment_cancels_updated_by_id_fk"
  add_foreign_key "appointment_credits", "companies", name: "appointment_credits_company_id_fk"
  add_foreign_key "appointment_credits", "shifts", name: "appointment_credits_shift_id_fk"
  add_foreign_key "appointment_credits", "users", column: "created_by_id", name: "appointment_credits_created_by_id_fk"
  add_foreign_key "appointment_credits", "users", column: "updated_by_id", name: "appointment_credits_updated_by_id_fk"
  add_foreign_key "appointment_excepts", "users", column: "created_by_id", name: "appointment_excepts_created_by_id_fk"
  add_foreign_key "appointment_excepts", "users", column: "updated_by_id", name: "appointment_excepts_updated_by_id_fk"
  add_foreign_key "appointments", "companies", name: "appointments_company_id_fk"
  add_foreign_key "appointments", "employee_companies", name: "appointments_employee_company_id_fk"
  add_foreign_key "appointments", "shifts", name: "appointments_shift_id_fk"
  add_foreign_key "appointments", "users", column: "created_by_id", name: "appointments_created_by_id_fk"
  add_foreign_key "appointments", "users", column: "updated_by_id", name: "appointments_updated_by_id_fk"
  add_foreign_key "audiometries", "audiometries", column: "worsed_compared_to", name: "audiometries_worsed_compared_to_fk"
  add_foreign_key "audiometries", "treatments", name: "audiometries_treatment_id_fk"
  add_foreign_key "audiometries", "users", column: "created_by_id", name: "audiometries_created_by_id_fk"
  add_foreign_key "audiometries", "users", column: "updated_by_id", name: "audiometries_updated_by_id_fk"
  add_foreign_key "audiometry_result_trackings", "audiometries", column: "current", name: "audiometry_result_trackings_current_fk"
  add_foreign_key "audiometry_result_trackings", "audiometries", column: "original", name: "audiometry_result_trackings_original_fk"
  add_foreign_key "audiometry_result_trackings", "users", column: "created_by_id", name: "audiometry_result_trackings_created_by_id_fk"
  add_foreign_key "audiometry_result_trackings", "users", column: "updated_by_id", name: "audiometry_result_trackings_updated_by_id_fk"
  add_foreign_key "clinical_emergency_treatments", "treatments", name: "clinical_emergency_treatments_treatment_id_fk"
  add_foreign_key "clinical_emergency_treatments", "users", column: "created_by_id", name: "clinical_emergency_treatments_created_by_id_fk"
  add_foreign_key "clinical_emergency_treatments", "users", column: "updated_by_id", name: "clinical_emergency_treatments_updated_by_id_fk"
  add_foreign_key "clinical_treatments", "treatments", name: "clinical_treatments_treatment_id_fk"
  add_foreign_key "clinical_treatments", "users", column: "created_by_id", name: "clinical_treatments_created_by_id_fk"
  add_foreign_key "clinical_treatments", "users", column: "updated_by_id", name: "clinical_treatments_updated_by_id_fk"
  add_foreign_key "companies", "users", column: "created_by_id", name: "companies_created_by_id_fk"
  add_foreign_key "companies", "users", column: "updated_by_id", name: "companies_updated_by_id_fk"
  add_foreign_key "company_contacts", "companies", name: "company_contacts_company_id_fk"
  add_foreign_key "company_contacts", "users", column: "created_by_id", name: "company_contacts_created_by_id_fk"
  add_foreign_key "company_contacts", "users", column: "updated_by_id", name: "company_contacts_updated_by_id_fk"
  add_foreign_key "complete_report_queues", "users", name: "complete_report_queues_user_id_fk"
  add_foreign_key "emergency_infos", "treatments", name: "emergency_infos_treatment_id_fk"
  add_foreign_key "emergency_infos", "users", column: "created_by_id", name: "emergency_infos_created_by_id_fk"
  add_foreign_key "emergency_infos", "users", column: "local_ok_ambulance_user_id", name: "emergency_infos_local_ok_ambulance_user_id_fk"
  add_foreign_key "emergency_infos", "users", column: "local_ok_user_id", name: "emergency_infos_local_ok_user_id_fk"
  add_foreign_key "emergency_infos", "users", column: "updated_by_id", name: "emergency_infos_updated_by_id_fk"
  add_foreign_key "employee_companies", "companies", name: "employee_companies_company_id_fk"
  add_foreign_key "employee_companies", "employees", name: "employee_companies_employee_id_fk"
  add_foreign_key "employee_companies", "shifts", name: "employee_companies_shift_id_fk"
  add_foreign_key "employees", "users", column: "created_by_id", name: "employees_created_by_id_fk"
  add_foreign_key "employees", "users", column: "updated_by_id", name: "employees_updated_by_id_fk"
  add_foreign_key "external_medical_certificate_items", "cid10s", name: "external_medical_certificate_items_cid10_id_fk"
  add_foreign_key "external_medical_certificate_items", "external_medical_certificates", name: "emc_items_external_medical_certificate_id_fk"
  add_foreign_key "external_medical_certificates", "employee_companies", name: "external_medical_certificates_employee_company_id_fk"
  add_foreign_key "external_medical_certificates", "treatments", name: "external_medical_certificates_treatment_id_fk"
  add_foreign_key "external_medical_certificates", "users", column: "created_by_id", name: "external_medical_certificates_created_by_id_fk"
  add_foreign_key "external_medical_certificates", "users", column: "updated_by_id", name: "external_medical_certificates_updated_by_id_fk"
  add_foreign_key "external_reports", "audiometries", name: "external_reports_audiometry_id_fk"
  add_foreign_key "external_reports", "employees", name: "external_reports_employee_id_fk"
  add_foreign_key "external_reports", "spirometries", name: "external_reports_spirometry_id_fk"
  add_foreign_key "external_reports", "users", column: "created_by_id", name: "external_reports_created_by_id_fk"
  add_foreign_key "external_reports", "users", column: "updated_by_id", name: "external_reports_updated_by_id_fk"
  add_foreign_key "external_reports", "visiotests", name: "external_reports_visiotest_id_fk"
  add_foreign_key "nursing_doctors", "treatments", name: "nursing_doctors_treatment_id_fk"
  add_foreign_key "nursing_doctors", "users", column: "created_by_id", name: "nursing_doctors_created_by_id_fk"
  add_foreign_key "nursings", "treatments", name: "nursings_treatment_id_fk"
  add_foreign_key "nursings", "users", column: "created_by_id", name: "nursings_created_by_id_fk"
  add_foreign_key "occupational_treatments", "treatments", name: "occupational_treatments_treatment_id_fk"
  add_foreign_key "occupational_treatments", "users", column: "created_by_id", name: "occupational_treatments_created_by_id_fk"
  add_foreign_key "occupational_treatments", "users", column: "updated_by_id", name: "occupational_treatments_updated_by_id_fk"
  add_foreign_key "report_queries", "reports"
  add_foreign_key "screenings", "treatments", name: "screenings_treatment_id_fk"
  add_foreign_key "screenings", "users", column: "created_by_id", name: "screenings_created_by_id_fk"
  add_foreign_key "screenings", "users", column: "updated_by_id", name: "screenings_updated_by_id_fk"
  add_foreign_key "shifts", "users", column: "created_by_id", name: "shifts_created_by_id_fk"
  add_foreign_key "shifts", "users", column: "updated_by_id", name: "shifts_updated_by_id_fk"
  add_foreign_key "spirometries", "treatments", name: "spirometries_treatment_id_fk"
  add_foreign_key "spirometries", "users", column: "created_by_id", name: "spirometries_created_by_id_fk"
  add_foreign_key "spirometries", "users", column: "updated_by_id", name: "spirometries_updated_by_id_fk"
  add_foreign_key "treatment_cid10s", "accident_treatments", name: "treatment_cid10s_accident_treatment_id_fk"
  add_foreign_key "treatment_cid10s", "cid10s", name: "treatment_cid10s_cid10_id_fk"
  add_foreign_key "treatment_cid10s", "clinical_emergency_treatments", name: "treatment_cid10s_clinical_emergency_treatment_id_fk"
  add_foreign_key "treatment_cid10s", "clinical_treatments", name: "treatment_cid10s_clinical_treatment_id_fk"
  add_foreign_key "treatment_cid10s", "nursing_doctors", name: "treatment_cid10s_nursing_doctor_id_fk"
  add_foreign_key "treatment_cid10s", "occupational_treatments", name: "treatment_cid10s_occupational_treatment_id_fk"
  add_foreign_key "treatment_medical_certificates", "accident_treatments", name: "treatment_medical_certificates_accident_treatment_id_fk"
  add_foreign_key "treatment_medical_certificates", "cid10s", name: "treatment_medical_certificates_cid10_id_fk"
  add_foreign_key "treatment_medical_certificates", "clinical_emergency_treatments", name: "tmc_clinical_emergency_treatment_id_fk"
  add_foreign_key "treatment_medical_certificates", "clinical_treatments", name: "treatment_medical_certificates_clinical_treatment_id_fk"
  add_foreign_key "treatment_medical_certificates", "nursing_doctors", name: "treatment_medical_certificates_nursing_doctor_id_fk"
  add_foreign_key "treatment_medical_certificates", "occupational_treatments", name: "treatment_medical_certificates_occupational_treatment_id_fk"
  add_foreign_key "treatment_rests", "treatments", name: "treatment_rests_treatment_id_fk"
  add_foreign_key "treatment_rests", "users", column: "created_by_id", name: "treatment_rests_created_by_id_fk"
  add_foreign_key "treatment_rests", "users", column: "updated_by_id", name: "treatment_rests_updated_by_id_fk"
  add_foreign_key "treatments", "appointments", name: "treatments_appointment_id_fk"
  add_foreign_key "treatments", "employee_companies", name: "treatments_employee_company_id_fk"
  add_foreign_key "treatments", "users", column: "created_by_id", name: "treatments_created_by_id_fk"
  add_foreign_key "treatments", "users", column: "updated_by_id", name: "treatments_updated_by_id_fk"
  add_foreign_key "visiotests", "treatments", name: "visiotests_treatment_id_fk"
  add_foreign_key "visiotests", "users", column: "created_by_id", name: "visiotests_created_by_id_fk"
  add_foreign_key "visiotests", "users", column: "updated_by_id", name: "visiotests_updated_by_id_fk"
end
