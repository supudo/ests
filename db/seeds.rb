# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Technology.delete_all
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