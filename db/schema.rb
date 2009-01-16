# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090116123759) do

  create_table "appendixes", :force => true do |t|
    t.string   "filename"
    t.string   "thumbnail"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.integer  "page_id"
    t.string   "class_name",   :default => "Image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appendixes", ["class_name"], :name => "index_appendixes_on_class_name"
  add_index "appendixes", ["filename"], :name => "index_appendixes_on_filename"

  create_table "config", :force => true do |t|
    t.string "key"
    t.string "value"
    t.string "option_type", :default => "text"
    t.string "values"
  end

  add_index "config", ["key"], :name => "index_config_on_key"
  add_index "config", ["value"], :name => "index_config_on_value"

  create_table "layouts", :force => true do |t|
    t.string "name"
    t.text   "content"
    t.string "content_type", :default => "text/html"
  end

  create_table "menu_items", :force => true do |t|
    t.string   "name"
    t.string   "link"
    t.integer  "parent_id"
    t.integer  "menu_id"
    t.integer  "position"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "published",  :limit => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_parts", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_versions", :force => true do |t|
    t.integer  "page_id"
    t.integer  "version"
    t.string   "title"
    t.string   "slug"
    t.string   "description"
    t.string   "keywords"
    t.string   "language"
    t.text     "body"
    t.string   "class_name",  :default => "Page"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "parent_id"
    t.integer  "status_id",   :default => 1
    t.integer  "layout_id",   :default => 1
    t.integer  "template_id", :default => 1
    t.integer  "author_id",   :default => 1
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.string   "description"
    t.string   "keywords"
    t.string   "language"
    t.text     "body"
    t.string   "class_name",  :default => "Page"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "parent_id"
    t.integer  "status_id",   :default => 1
    t.integer  "layout_id",   :default => 1
    t.integer  "template_id", :default => 1
    t.integer  "author_id",   :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "version"
  end

  add_index "pages", ["class_name"], :name => "index_pages_on_class_name"
  add_index "pages", ["slug"], :name => "index_pages_on_slug"
  add_index "pages", ["title"], :name => "index_pages_on_title"

  create_table "permissions", :force => true do |t|
    t.string "identifier"
  end

  create_table "permissions_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "permission_id"
  end

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "full_name"
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count"
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.string   "perishable_token",  :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

end
