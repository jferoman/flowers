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

ActiveRecord::Schema.define(version: 20170825001429) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bus_service_assignations", force: :cascade do |t|
    t.integer "typology_code", null: false
    t.bigint "bus_service_id", null: false
    t.bigint "company_id", null: false
    t.bigint "initial_depot_id", null: false
    t.bigint "final_depot_id", null: false
    t.bigint "valley_depot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bus_service_id"], name: "index_bus_service_assignations_on_bus_service_id"
    t.index ["company_id"], name: "index_bus_service_assignations_on_company_id"
    t.index ["final_depot_id"], name: "index_bus_service_assignations_on_final_depot_id"
    t.index ["initial_depot_id"], name: "index_bus_service_assignations_on_initial_depot_id"
    t.index ["valley_depot_id"], name: "index_bus_service_assignations_on_valley_depot_id"
  end

  create_table "bus_services", force: :cascade do |t|
    t.string "code", null: false
    t.integer "initial_point"
    t.integer "final_point"
    t.decimal "start_time", precision: 10, scale: 6
    t.decimal "finish_time", precision: 10, scale: 6
    t.decimal "amplitude", precision: 10, scale: 6
    t.integer "typology"
    t.integer "service_type"
    t.bigint "time_table_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code", "time_table_id"], name: "index_bus_services_on_code_and_time_table_id", unique: true
    t.index ["time_table_id"], name: "index_bus_services_on_time_table_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.date "executed_date", null: false
    t.bigint "iph_date_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iph_date_id"], name: "index_calendars_on_iph_date_id"
  end

  create_table "commercial_arches", force: :cascade do |t|
    t.string "ruta", null: false
    t.integer "macro", null: false
    t.integer "linea", null: false
    t.integer "seccion", null: false
    t.integer "nodo", null: false
    t.string "nombre", null: false
    t.integer "abscisa", null: false
    t.integer "distance_to_last_point"
    t.bigint "commercial_matrix_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commercial_matrix_id"], name: "index_commercial_arches_on_commercial_matrix_id"
    t.index ["macro", "linea", "seccion", "nodo", "commercial_matrix_id"], name: "commercial_archers_index", unique: true
  end

  create_table "commercial_matrices", force: :cascade do |t|
    t.string "name"
    t.date "date_of_creation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "letter", null: false
    t.string "name", null: false
    t.string "gams_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dead_arches", force: :cascade do |t|
    t.integer "initial_point", null: false
    t.integer "final_point", null: false
    t.string "arch", null: false
    t.string "time", null: false
    t.decimal "decimal_time", precision: 10, scale: 6
    t.integer "distance", null: false
    t.bigint "dead_matrix_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dead_matrix_id"], name: "index_dead_arches_on_dead_matrix_id"
    t.index ["initial_point", "final_point", "dead_matrix_id"], name: "dead_archers_index", unique: true
  end

  create_table "dead_matrices", force: :cascade do |t|
    t.string "name"
    t.date "date_of_creation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "depots", force: :cascade do |t|
    t.integer "point", null: false
    t.string "name", null: false
    t.string "gams_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "tipo_dia", null: false
    t.string "instante", null: false
    t.string "servbus", null: false
    t.integer "evento", null: false
    t.integer "macro", null: false
    t.integer "linea", null: false
    t.integer "coche", null: false
    t.integer "sublinea", null: false
    t.integer "seccion", null: false
    t.integer "punto", null: false
    t.integer "tipo", null: false
    t.integer "viaje", null: false
    t.integer "bus_service_order"
    t.string "reference"
    t.string "event_type"
    t.string "fase"
    t.string "dead_arch_status"
    t.string "commercial_arch_status"
    t.bigint "bus_service_id", null: false
    t.bigint "time_table_id"
    t.bigint "commercial_arch_id"
    t.bigint "dead_arch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bus_service_id"], name: "index_events_on_bus_service_id"
    t.index ["commercial_arch_id"], name: "index_events_on_commercial_arch_id"
    t.index ["dead_arch_id"], name: "index_events_on_dead_arch_id"
    t.index ["time_table_id"], name: "index_events_on_time_table_id"
  end

  create_table "iph_dates", force: :cascade do |t|
    t.date "date_of_creation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reference_fleets", force: :cascade do |t|
    t.integer "ref_articulated_buses"
    t.integer "ref_biarticulated_buses"
    t.integer "ref_additional_articulated_buses"
    t.integer "ref_additional_biarticulated_buses"
    t.decimal "articulated_participation", precision: 10, scale: 6
    t.decimal "biarticulated_participation", precision: 10, scale: 6
    t.integer "articulated_buses"
    t.integer "biarticulated_buses"
    t.decimal "target_commercial_distance_art", precision: 10, scale: 6
    t.decimal "target_commercial_distance_biart", precision: 10, scale: 6
    t.bigint "company_id"
    t.bigint "time_table_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_reference_fleets_on_company_id"
    t.index ["time_table_id"], name: "index_reference_fleets_on_time_table_id"
  end

  create_table "time_tables", force: :cascade do |t|
    t.date "time_table_date", null: false
    t.date "commercial_matrix_date"
    t.date "dead_matrix_date"
    t.string "description"
    t.string "initial_parsing_status"
    t.string "bus_service_status"
    t.integer "commercial_distance"
    t.integer "fixed_dead_distance"
    t.string "commercial_status"
    t.string "dead_status"
    t.bigint "commercial_matrix_id"
    t.bigint "dead_matrix_id"
    t.bigint "iph_date_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commercial_matrix_id"], name: "index_time_tables_on_commercial_matrix_id"
    t.index ["dead_matrix_id"], name: "index_time_tables_on_dead_matrix_id"
    t.index ["iph_date_id"], name: "index_time_tables_on_iph_date_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "valley_depot_entries", force: :cascade do |t|
    t.string "code"
    t.integer "initial_point"
    t.integer "final_point"
    t.integer "original_depot_point"
    t.decimal "start_time", precision: 10, scale: 6
    t.decimal "finish_time", precision: 10, scale: 6
    t.decimal "amplitude"
    t.bigint "initial_event_id"
    t.bigint "valley_entry_event_id"
    t.bigint "valley_exit_event_id"
    t.bigint "final_event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["final_event_id"], name: "index_valley_depot_entries_on_final_event_id"
    t.index ["initial_event_id"], name: "index_valley_depot_entries_on_initial_event_id"
    t.index ["valley_entry_event_id"], name: "index_valley_depot_entries_on_valley_entry_event_id"
    t.index ["valley_exit_event_id"], name: "index_valley_depot_entries_on_valley_exit_event_id"
  end

end
