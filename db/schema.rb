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

ActiveRecord::Schema.define(version: 20171206201028) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bed_productions", force: :cascade do |t|
    t.integer "quantity", null: false
    t.string "status", null: false
    t.bigint "variety_id", null: false
    t.bigint "bed_id", null: false
    t.bigint "week_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bed_id"], name: "index_bed_productions_on_bed_id"
    t.index ["variety_id", "bed_id", "week_id", "status"], name: "bed_production_status", unique: true
    t.index ["variety_id"], name: "index_bed_productions_on_variety_id"
    t.index ["week_id"], name: "index_bed_productions_on_week_id"
  end

  create_table "bed_types", force: :cascade do |t|
    t.string "name", null: false
    t.integer "width", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "width"], name: "index_bed_types_on_name_and_width", unique: true
  end

  create_table "beds", force: :cascade do |t|
    t.string "number", null: false
    t.float "total_area", null: false
    t.float "usable_area", null: false
    t.bigint "block_id", null: false
    t.bigint "bed_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bed_type_id"], name: "index_beds_on_bed_type_id"
    t.index ["block_id"], name: "index_beds_on_block_id"
    t.index ["number", "block_id"], name: "index_beds_on_number_and_block_id", unique: true
    t.index ["number"], name: "index_beds_on_number"
  end

  create_table "block_color_flowers", force: :cascade do |t|
    t.boolean "usage", null: false
    t.bigint "block_id", null: false
    t.bigint "flower_id", null: false
    t.bigint "color_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["block_id", "flower_id", "color_id"], name: "block_color_flower", unique: true
    t.index ["block_id"], name: "index_block_color_flowers_on_block_id"
    t.index ["color_id"], name: "index_block_color_flowers_on_color_id"
    t.index ["flower_id"], name: "index_block_color_flowers_on_flower_id"
  end

  create_table "blocks", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "farm_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id"], name: "index_blocks_on_farm_id"
    t.index ["name", "farm_id"], name: "index_blocks_on_name_and_farm_id", unique: true
  end

  create_table "coldrooms", force: :cascade do |t|
    t.string "name", null: false
    t.integer "capacity", null: false
    t.bigint "farm_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id"], name: "index_coldrooms_on_farm_id"
    t.index ["name", "farm_id"], name: "index_coldrooms_on_name_and_farm_id", unique: true
  end

  create_table "color_submarkets", force: :cascade do |t|
    t.float "price", null: false
    t.boolean "default", null: false
    t.bigint "color_id", null: false
    t.bigint "submarket_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["color_id", "submarket_id"], name: "index_color_submarkets_on_color_id_and_submarket_id", unique: true
    t.index ["color_id"], name: "index_color_submarkets_on_color_id"
    t.index ["submarket_id"], name: "index_color_submarkets_on_submarket_id"
  end

  create_table "colors", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_colors_on_name"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.integer "nit", null: false
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cuttings", force: :cascade do |t|
    t.integer "quantity", null: false
    t.string "status", null: false
    t.bigint "farm_id", null: false
    t.bigint "week_id", null: false
    t.bigint "variety_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id"], name: "index_cuttings_on_farm_id"
    t.index ["variety_id"], name: "index_cuttings_on_variety_id"
    t.index ["week_id"], name: "index_cuttings_on_week_id"
  end

  create_table "demands", force: :cascade do |t|
    t.integer "quantity", null: false
    t.bigint "color_id", null: false
    t.bigint "flower_id", null: false
    t.bigint "market_id", null: false
    t.bigint "week_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["color_id", "flower_id", "market_id", "week_id"], name: "demand_color_flower_market", unique: true
    t.index ["color_id"], name: "index_demands_on_color_id"
    t.index ["flower_id"], name: "index_demands_on_flower_id"
    t.index ["market_id"], name: "index_demands_on_market_id"
    t.index ["week_id"], name: "index_demands_on_week_id"
  end

  create_table "farms", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.float "mamsl"
    t.float "pluviosity"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_farms_on_company_id"
  end

  create_table "flower_densities", force: :cascade do |t|
    t.float "density", null: false
    t.bigint "farm_id", null: false
    t.bigint "flower_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id", "flower_id"], name: "index_flower_densities_on_farm_id_and_flower_id", unique: true
    t.index ["farm_id"], name: "index_flower_densities_on_farm_id"
    t.index ["flower_id"], name: "index_flower_densities_on_flower_id"
  end

  create_table "flowers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "markets", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_markets_on_company_id"
  end

  create_table "productions", force: :cascade do |t|
    t.integer "quantity", null: false
    t.string "status", null: false
    t.bigint "variety_id", null: false
    t.bigint "farm_id", null: false
    t.bigint "week_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id"], name: "index_productions_on_farm_id"
    t.index ["variety_id", "farm_id", "week_id", "status"], name: "production_status", unique: true
    t.index ["variety_id"], name: "index_productions_on_variety_id"
    t.index ["week_id"], name: "index_productions_on_week_id"
  end

  create_table "productivity_curves", force: :cascade do |t|
    t.integer "week_number", null: false
    t.float "cost", null: false
    t.integer "production", null: false
    t.integer "cut", null: false
    t.bigint "farm_id", null: false
    t.bigint "variety_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id"], name: "index_productivity_curves_on_farm_id"
    t.index ["variety_id"], name: "index_productivity_curves_on_variety_id"
    t.index ["week_number", "farm_id", "variety_id"], name: "productivity_curve", unique: true
  end

  create_table "sowing_details", force: :cascade do |t|
    t.integer "quantity", null: false
    t.integer "cutting_week", null: false
    t.bigint "variety_id", null: false
    t.bigint "week_id", null: false
    t.bigint "bed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bed_id"], name: "index_sowing_details_on_bed_id"
    t.index ["variety_id", "bed_id", "week_id"], name: "sowing_detail", unique: true
    t.index ["variety_id"], name: "index_sowing_details_on_variety_id"
    t.index ["week_id"], name: "index_sowing_details_on_week_id"
  end

  create_table "sowing_solutions", force: :cascade do |t|
    t.integer "bed_number", null: false
    t.bigint "block_id", null: false
    t.bigint "bed_type_id", null: false
    t.bigint "variety_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bed_type_id"], name: "index_sowing_solutions_on_bed_type_id"
    t.index ["block_id"], name: "index_sowing_solutions_on_block_id"
    t.index ["variety_id"], name: "index_sowing_solutions_on_variety_id"
  end

  create_table "storage_resistance_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "storage_resistances", force: :cascade do |t|
    t.integer "week_number", null: false
    t.float "lost_percentage", null: false
    t.bigint "storage_resistance_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["storage_resistance_type_id"], name: "index_storage_resistances_on_storage_resistance_type_id"
  end

  create_table "submarket_weeks", force: :cascade do |t|
    t.bigint "week_id"
    t.bigint "submarket_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["submarket_id"], name: "index_submarket_weeks_on_submarket_id"
    t.index ["week_id", "submarket_id"], name: "index_submarket_weeks_on_week_id_and_submarket_id", unique: true
    t.index ["week_id"], name: "index_submarket_weeks_on_week_id"
  end

  create_table "submarkets", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.bigint "market_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["market_id"], name: "index_submarkets_on_market_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "admin", default: false
    t.integer "default_farm", null: false
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
  end

  create_table "varieties", force: :cascade do |t|
    t.float "participation", null: false
    t.string "name", null: false
    t.bigint "storage_resistance_type_id", null: false
    t.bigint "flower_id", null: false
    t.bigint "color_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["color_id"], name: "index_varieties_on_color_id"
    t.index ["flower_id"], name: "index_varieties_on_flower_id"
    t.index ["name", "flower_id"], name: "index_varieties_on_name_and_flower_id", unique: true
    t.index ["storage_resistance_type_id"], name: "index_varieties_on_storage_resistance_type_id"
  end

  create_table "weeks", force: :cascade do |t|
    t.date "initial_day", null: false
    t.integer "week", null: false
    t.integer "model_week"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["initial_day", "week"], name: "index_weeks_on_initial_day_and_week", unique: true
    t.index ["week"], name: "index_weeks_on_week"
  end

end
