# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Technology.delete_all
Technology.create(:id => 1, :title => 'Management', :style => '#EB2D32', :is_rated => 1)
Technology.create(:id => 2, :title => '.NET', :style => '#AC0FBA', :is_rated => 1)
Technology.create(:id => 3, :title => 'PHP', :style => '#8893BE', :is_rated => 1)

Position.delete_all
Position.create(:id => 1, :technology_id => 1, :complexity => 1, :is_am => 1, :is_pdm => 0, :is_rated => 0, :title => 'Account Manager')
Position.create(:id => 2, :technology_id => 1, :complexity => 2, :is_am => 0, :is_pdm => 1, :is_rated => 0, :title => 'Production Manager')
Position.create(:id => 3, :technology_id => 2, :complexity => 1, :is_am => 0, :is_pdm => 0, :is_rated => 1, :title => 'Developer')
Position.create(:id => 4, :technology_id => 2, :complexity => 2, :is_am => 0, :is_pdm => 0, :is_rated => 1, :title => 'Senior Developer')
Position.create(:id => 5, :technology_id => 2, :complexity => 3, :is_am => 0, :is_pdm => 0, :is_rated => 1, :title => 'Team Leader')
Position.create(:id => 5, :technology_id => 3, :complexity => 1, :is_am => 0, :is_pdm => 0, :is_rated => 1, :title => 'Developer')
Position.create(:id => 7, :technology_id => 3, :complexity => 2, :is_am => 0, :is_pdm => 0, :is_rated => 1, :title => 'Senior Developer')
Position.create(:id => 8, :technology_id => 3, :complexity => 3, :is_am => 0, :is_pdm => 0, :is_rated => 1, :title => 'Team Leader')

Client.delete_all
Client.create(:id => 1, :title => 'Ests', :email => 'ests@ests.com', :url => 'http://www.ests.com/', :phone => '')

Currency.delete_all
Currency.create(:id => 1, :code => 'USD', :symbol => '$', :is_infront => 1, :title => 'US Dollar')
Currency.create(:id => 2, :code => 'EUR', :symbol => '€', :is_infront => 1, :title => 'Euro')
Currency.create(:id => 3, :code => 'CHF', :symbol => 'Fr.', :is_infront => 0, :title => 'Swiss Franc')

EngagementModel.delete_all
EngagementModel.create(:id => 1, :title => 'Fixed Price')

Rate.delete_all
Rate.create(:id => 1, :currency_id => 1, :title => 'Rate USD')
Rate.create(:id => 2, :currency_id => 2, :title => 'Rate EUR')
Rate.create(:id => 3, :currency_id => 3, :title => 'Rate CHF')

ProjectStatus.delete_all
ProjectStatus.create(:id => 1, :title => 'Undefined')
ProjectStatus.create(:id => 2, :title => 'Communication')
ProjectStatus.create(:id => 3, :title => 'Completed')
ProjectStatus.create(:id => 4, :title => 'Ongoing')
ProjectStatus.create(:id => 5, :title => 'Review')
ProjectStatus.create(:id => 6, :title => 'Waiting')
ProjectStatus.create(:id => 7, :title => 'Archived')
ProjectStatus.create(:id => 8, :title => 'Guarantee')
ProjectStatus.create(:id => 9, :title => 'Upcomming')
ProjectStatus.create(:id => 10, :title => 'Scheduled')
ProjectStatus.create(:id => 10, :title => 'Rejected')

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