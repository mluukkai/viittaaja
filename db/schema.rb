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

ActiveRecord::Schema.define(version: 20160501182904) do

  create_table "referencelists", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "references", force: :cascade do |t|
    t.integer  "year"
    t.string   "publisher"
    t.string   "author"
    t.string   "title"
    t.string   "address"
    t.string   "pages"
    t.integer  "volume"
    t.string   "edition"
    t.string   "month"
    t.integer  "series"
    t.string   "note"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "organization"
    t.string   "volume_number"
    t.string   "editor"
    t.string   "booktitle"
    t.string   "key"
    t.integer  "number"
    t.string   "journal"
    t.string   "reference_type"
    t.string   "citation_key"
  end

  create_table "references_tags", id: false, force: :cascade do |t|
    t.integer "reference_id"
    t.integer "tag_id"
  end

  add_index "references_tags", ["reference_id"], name: "index_references_tags_on_reference_id"
  add_index "references_tags", ["tag_id"], name: "index_references_tags_on_tag_id"

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
