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

ActiveRecord::Schema.define(version: 20170518133148) do

  create_table "products", force: :cascade do |t|
    t.string   "prodName"
    t.string   "prodNum"
    t.string   "prodSupplierNum"
    t.string   "prodUTASowners"
    t.string   "prodSupplier"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "records", force: :cascade do |t|
    t.string   "serialNum"
    t.string   "product"
    t.string   "partNum"
    t.date     "removalDate"
    t.string   "owner"
    t.string   "status"
    t.string   "location"
    t.date     "resolveBy"
    t.text     "removalReason"
    t.text     "comments"
    t.string   "supplier"
    t.string   "utasPO"
    t.string   "pwPO"
    t.string   "qn"
    t.boolean  "resolved"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "actionRequiredBy"
    t.string   "d3QN"
    t.string   "v2QN"
    t.string   "removalLocation"
    t.string   "program"
    t.date     "dateResolved"
    t.text     "fullChangelog"
  end

end
