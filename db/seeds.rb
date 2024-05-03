# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

u = User.create! username: "owentest", password: "password123", password_confirmation: "password123", id: "f1c1c3c0-1c3c-4c1c-9c1c-1c3c1c3c1c3c"
u.people.create! name: "owen", system_prompt: "You are a helpful assistant.", id: "f1b1b3b0-1b3b-4b1b-9b1b-1b3b1b3b1b3b"