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

ActiveRecord::Schema[7.1].define(version: 2024_05_02_320009) do
# Could not dump table "active_storage_attachments" because of following StandardError
#   Unknown type 'uuid' for column 'id'

# Could not dump table "active_storage_blobs" because of following StandardError
#   Unknown type 'uuid' for column 'id'

# Could not dump table "active_storage_variant_records" because of following StandardError
#   Unknown type 'uuid' for column 'id'

# Could not dump table "chats" because of following StandardError
#   Unknown type 'uuid' for column 'id'

# Could not dump table "documents" because of following StandardError
#   Unknown type 'uuid' for column 'id'

# Could not dump table "friends" because of following StandardError
#   Unknown type 'uuid' for column 'id'

# Could not dump table "memories" because of following StandardError
#   Unknown type 'uuid' for column 'id'

# Could not dump table "messages" because of following StandardError
#   Unknown type 'uuid' for column 'id'

# Could not dump table "users" because of following StandardError
#   Unknown type 'uuid' for column 'id'

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chats", "friends"
  add_foreign_key "chats", "users"
  add_foreign_key "documents", "friends"
  add_foreign_key "friends", "users"
  add_foreign_key "memories", "chats"
  add_foreign_key "memories", "documents"
  add_foreign_key "memories", "friends"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "users"
end
