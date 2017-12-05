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

ActiveRecord::Schema.define(version: 20171204174510) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.boolean "usage"
    t.bigint "block_id"
    t.bigint "flower_id"
    t.bigint "color_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "color_submarkets", force: :cascade do |t|
    t.float "price"
    t.boolean "default"
    t.bigint "color_id"
    t.bigint "submarket_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["color_id"], name: "index_color_submarkets_on_color_id"
    t.index ["submarket_id"], name: "index_color_submarkets_on_submarket_id"
  end

  create_table "colors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.integer "nit", null: false
    t.integer "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cuttings", force: :cascade do |t|
    t.integer "quantity"
    t.bigint "week_id"
    t.bigint "variety_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["variety_id"], name: "index_cuttings_on_variety_id"
    t.index ["week_id"], name: "index_cuttings_on_week_id"
  end

  create_table "demands", force: :cascade do |t|
    t.integer "quantity"
    t.bigint "company_id"
    t.bigint "color_id"
    t.bigint "flower_id"
    t.bigint "market_id"
    t.bigint "week_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["color_id"], name: "index_demands_on_color_id"
    t.index ["company_id"], name: "index_demands_on_company_id"
    t.index ["flower_id"], name: "index_demands_on_flower_id"
    t.index ["market_id"], name: "index_demands_on_market_id"
    t.index ["week_id"], name: "index_demands_on_week_id"
  end

  create_table "farms", force: :cascade do |t|
    t.string "code", null: false
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
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "markets", force: :cascade do |t|
    t.string "code"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "productivity_curves", force: :cascade do |t|
    t.integer "week_number"
    t.float "cost"
    t.integer "production"
    t.integer "cut"
    t.bigint "farm_id"
    t.bigint "variety_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id"], name: "index_productivity_curves_on_farm_id"
    t.index ["variety_id"], name: "index_productivity_curves_on_variety_id"
  end

  create_table "sowing_details", force: :cascade do |t|
    t.integer "quantity"
    t.bigint "variety_id"
    t.bigint "week_id"
    t.bigint "bed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bed_id"], name: "index_sowing_details_on_bed_id"
    t.index ["variety_id"], name: "index_sowing_details_on_variety_id"
    t.index ["week_id"], name: "index_sowing_details_on_week_id"
  end

  create_table "storage_resistance_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "storage_resistances", force: :cascade do |t|
    t.integer "week_number"
    t.float "lost_percentage"
    t.bigint "storage_resistance_type_id"
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
    t.index ["week_id"], name: "index_submarket_weeks_on_week_id"
  end

  create_table "submarkets", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.bigint "market_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["market_id"], name: "index_submarkets_on_market_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "admin"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
  end

  create_table "varieties", force: :cascade do |t|
    t.float "participation"
    t.bigint "storage_resistance_type_id"
    t.bigint "flower_id"
    t.bigint "color_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["color_id"], name: "index_varieties_on_color_id"
    t.index ["flower_id"], name: "index_varieties_on_flower_id"
    t.index ["storage_resistance_type_id"], name: "index_varieties_on_storage_resistance_type_id"
  end

  create_table "weeks", force: :cascade do |t|
    t.date "initial_day"
    t.integer "week"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
