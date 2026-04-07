# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

%w[ GIS AR Simulation ].each do |service_name|
  Service.find_or_create_by!(name: service_name)
end

admin_user = User.create!(email: "admin@example.com", password: "password123", first_name: "Admin", last_name: "User", role: :admin)
gis_user = User.create!(email: "gis@example.com", password: "password123", first_name: "GIS", last_name: "User", role: :user)
ar_user = User.create!(email: "ar@example.com", password: "password123", first_name: "AR", last_name: "User", role: :user)
simulation_user = User.create!(email: "simulation@example.com", password: "password123", first_name: "Simulation", last_name: "User", role: :user)

admin_user.services << Service.where(name: %w[ GIS AR Simulation ])
gis_user.services << Service.find_by!(name: "GIS")
ar_user.services << Service.find_by!(name: "AR")
simulation_user.services << Service.find_by!(name: "Simulation")
