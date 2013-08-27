# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Note.destroy_all

words = %w{ruby rails javascript html css jquery api callback ajax database hack issue}

10.times do
  note = Note.create(title: words.sample(rand(4) + 2).join(' '), text: Faker::Lorem.paragraphs(10).join("\n\n"))
end
