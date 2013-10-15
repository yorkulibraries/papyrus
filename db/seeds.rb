# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# admin user 
admin = User.new
admin.username = "admin"
admin.email = "admin@library-york-test.ca"
admin.name = "Admin User"
admin.role = User::ADMIN
admin.inactive = false
admin.save