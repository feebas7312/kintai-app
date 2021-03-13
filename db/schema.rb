# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_16_015434) do

  create_table "admin_work_patterns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "admin_id"
    t.bigint "work_pattern_id"
    t.boolean "possibility", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_admin_work_patterns_on_admin_id"
    t.index ["work_pattern_id"], name: "index_admin_work_patterns_on_work_pattern_id"
  end

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "number", null: false
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.date "birth_date", null: false
    t.string "phone_number"
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.date "joining_date", null: false
    t.integer "employment_status_id", null: false
    t.integer "salary_system_id", null: false
    t.integer "wages"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "postal_code"
    t.string "address"
    t.string "phone_number"
    t.integer "cutoff_date_id", null: false
    t.time "opening_time", null: false
    t.time "closing_time", null: false
    t.bigint "admin_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_companies_on_admin_id"
  end

  create_table "employee_work_patterns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "work_pattern_id"
    t.boolean "possibility", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employee_id"], name: "index_employee_work_patterns_on_employee_id"
    t.index ["work_pattern_id"], name: "index_employee_work_patterns_on_work_pattern_id"
  end

  create_table "employees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "number", null: false
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.date "birth_date", null: false
    t.string "phone_number"
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.date "joining_date", null: false
    t.integer "employment_status_id", null: false
    t.integer "salary_system_id", null: false
    t.integer "wages"
    t.bigint "admin_id", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_employees_on_admin_id"
    t.index ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true
  end

  create_table "work_patterns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "start_time", null: false
    t.string "end_time", null: false
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_work_patterns_on_company_id"
  end

  create_table "work_schedules", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "work_date", null: false
    t.string "work_start_time"
    t.string "work_end_time"
    t.bigint "admin_id"
    t.bigint "employee_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_work_schedules_on_admin_id"
    t.index ["employee_id"], name: "index_work_schedules_on_employee_id"
  end

  add_foreign_key "admin_work_patterns", "admins"
  add_foreign_key "admin_work_patterns", "work_patterns"
  add_foreign_key "companies", "admins"
  add_foreign_key "employee_work_patterns", "employees"
  add_foreign_key "employee_work_patterns", "work_patterns"
  add_foreign_key "employees", "admins"
  add_foreign_key "work_patterns", "companies"
  add_foreign_key "work_schedules", "admins"
  add_foreign_key "work_schedules", "employees"
end
