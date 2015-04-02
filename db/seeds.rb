# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Technology.delete_all
Technology.create(:title => 'C-Level')
Technology.create(:title => 'Management')
Technology.create(:title => '.NET')
Technology.create(:title => 'PHP')
Technology.create(:title => 'FE')
Technology.create(:title => 'Design')
Technology.create(:title => 'QA')

Position.delete_all
Position.create(:title => 'CEO')
Position.create(:title => 'CFO')
Position.create(:title => 'CTO')
Position.create(:title => 'DO')
Position.create(:title => 'DT')
Position.create(:title => 'PdM')
Position.create(:title => 'TPM')
Position.create(:title => 'PM')
Position.create(:title => 'Team Leader')
Position.create(:title => 'Developer')

Client.delete_all
Client.create(:id => 1, :title => 'Ests', :email => 'ests@ests.com', :url => 'http://www.ests.com/', :phone => '+3591234567890')

Permission.delete_all
Permission.create(:title => 'login')
Permission.create(:title => 'profile')
Permission.create(:title => 'view_technology')
Permission.create(:title => 'create_technology')
Permission.create(:title => 'modify_technology')
Permission.create(:title => 'delete_technology')
Permission.create(:title => 'view_position')
Permission.create(:title => 'create_position')
Permission.create(:title => 'modify_position')
Permission.create(:title => 'delete_position')
Permission.create(:title => 'view_project')
Permission.create(:title => 'create_project')
Permission.create(:title => 'modify_project')
Permission.create(:title => 'delete_project')
Permission.create(:title => 'view_client')
Permission.create(:title => 'create_client')
Permission.create(:title => 'modify_client')
Permission.create(:title => 'delete_client')
Permission.create(:title => 'view_rate')
Permission.create(:title => 'create_rate')
Permission.create(:title => 'modify_rate')
Permission.create(:title => 'delete_rate')
Permission.create(:title => 'view_estimate')
Permission.create(:title => 'create_estimate')
Permission.create(:title => 'modify_estimate')
Permission.create(:title => 'delete_estimate')