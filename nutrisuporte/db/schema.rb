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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150415141330) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "assets", :force => true do |t|
    t.string   "storage_uid"
    t.string   "storage_name"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "storage_width"
    t.integer  "storage_height"
    t.float    "storage_aspect_ratio"
    t.integer  "storage_depth"
    t.string   "storage_format"
    t.string   "storage_mime_type"
    t.string   "storage_size"
  end

  create_table "blog_posts", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "content"
    t.string   "image"
    t.boolean  "is_draft"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "blog_posts", ["url"], :name => "index_blog_posts_on_url"

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "image"
    t.boolean  "is_available"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "moip_nasps", :force => true do |t|
    t.integer  "id_transacao"
    t.decimal  "valor"
    t.integer  "status_pagamento"
    t.string   "cod_moip"
    t.string   "forma_pagamento"
    t.string   "tipo_pagamento"
    t.integer  "parcelas"
    t.string   "email_consumidor"
    t.string   "recebedor_login"
    t.string   "cartao_bin"
    t.string   "cartao_final"
    t.string   "cartao_bandeira"
    t.string   "cofre"
    t.string   "classificacao"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "motoboy_fixed_price_for_cities", :force => true do |t|
    t.string   "city"
    t.string   "state"
    t.decimal  "price"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "days",       :default => 1
  end

  create_table "motoboy_neighbourhood_prices", :force => true do |t|
    t.string   "city"
    t.string   "state"
    t.string   "neighbourhood"
    t.decimal  "price"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "days",          :default => 1
  end

  create_table "nutrisuporte_settings", :force => true do |t|
    t.string   "banner_home_image"
    t.integer  "boleto_discount"
    t.integer  "debit_discount"
    t.decimal  "credit_card_interest"
    t.integer  "credit_card_max_payments"
    t.boolean  "show_banner_home"
    t.decimal  "minimum_size_payment"
    t.integer  "max_payments"
    t.string   "cep_origem"
    t.boolean  "motoboy_available"
    t.string   "correios_cod_empresa"
    t.string   "correios_senha"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "main_phone"
    t.string   "email"
    t.string   "address"
    t.string   "open_time"
    t.text     "terms_of_use"
    t.text     "about_page"
    t.decimal  "max_weight"
    t.boolean  "get_on_store_available"
    t.string   "get_on_store_message"
    t.integer  "max_payments_display"
  end

  create_table "order_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "qty"
    t.decimal  "price"
    t.string   "product_name"
    t.string   "product_subtitle"
    t.string   "product_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"
  add_index "order_items", ["product_id"], :name => "index_order_items_on_product_id"

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "total"
    t.decimal  "total_shipping"
    t.decimal  "total_discount"
    t.string   "delivery_method"
    t.string   "status",                 :default => "1"
    t.datetime "canceled_at"
    t.datetime "payed_at"
    t.datetime "shipped_at"
    t.string   "payment_method"
    t.string   "nf_number"
    t.boolean  "is_gift"
    t.string   "payment_name"
    t.string   "payment_address"
    t.string   "payment_complement"
    t.string   "payment_neighbourhood"
    t.string   "payment_cep"
    t.string   "payment_city"
    t.string   "payment_state"
    t.string   "delivery_name"
    t.string   "delivery_address"
    t.string   "delivery_complement"
    t.string   "delivery_neighbourhood"
    t.string   "delivery_cep"
    t.string   "delivery_city"
    t.string   "delivery_state"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "delivery_days"
    t.decimal  "credit_card_interest"
    t.integer  "payments"
  end

  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "product_categories", :force => true do |t|
    t.integer  "product_category_id"
    t.string   "name"
    t.string   "subtitle"
    t.string   "url"
    t.integer  "relevance"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "product_relateds", :force => true do |t|
    t.integer  "product_id"
    t.integer  "related_product_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "product_relateds", ["product_id"], :name => "index_product_relateds_on_product_id"

  create_table "product_subscriptions", :force => true do |t|
    t.integer  "product_id"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "product_subscriptions", ["product_id"], :name => "index_product_subscriptions_on_product_id"

  create_table "product_types", :force => true do |t|
    t.integer  "product_id"
    t.integer  "qty"
    t.integer  "weight"
    t.string   "name"
    t.boolean  "is_available"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "height"
    t.integer  "width"
    t.integer  "length"
  end

  add_index "product_types", ["product_id"], :name => "index_product_types_on_product_id"

  create_table "products", :force => true do |t|
    t.integer  "brand_id"
    t.integer  "product_category_id"
    t.string   "name"
    t.string   "url"
    t.string   "subtitle"
    t.text     "description"
    t.decimal  "price"
    t.decimal  "original_price"
    t.boolean  "is_available"
    t.boolean  "is_featured"
    t.string   "image"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.boolean  "is_new_product"
  end

  add_index "products", ["brand_id"], :name => "index_products_on_brand_id"
  add_index "products", ["product_category_id"], :name => "index_products_on_product_category_id"
  add_index "products", ["url"], :name => "index_products_on_url"

  create_table "slider_home_items", :force => true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.text     "description"
    t.decimal  "price"
    t.string   "price_subtitle"
    t.integer  "relevance"
    t.text     "url"
    t.string   "background_image"
    t.string   "image"
    t.boolean  "is_available"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.boolean  "display_picture_only"
  end

  create_table "user_addresses", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "is_default"
    t.string   "name"
    t.string   "address"
    t.string   "number"
    t.string   "complement"
    t.string   "neighbourhood"
    t.string   "cep"
    t.string   "city"
    t.string   "state"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "user_addresses", ["user_id"], :name => "index_user_addresses_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "user_type"
    t.string   "cpf"
    t.string   "cnpj"
    t.string   "phone"
    t.string   "mobile"
    t.string   "name"
    t.string   "gender"
    t.string   "company_name"
    t.string   "state_registration"
    t.date     "birth_date"
    t.boolean  "email_news"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
