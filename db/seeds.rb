# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 10.times do
#   Category.create(title: Faker::Book.genre)
# end

# 20.times do
#   FactoryGirl.create(:post)
# end

20.times do
  Tag.create(name: Faker::Hipster.word)
end
