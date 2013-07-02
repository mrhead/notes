# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Note.destroy_all

10.times do
	note = Note.create(title: Faker::Lorem.sentence, text: Faker::Lorem.paragraphs.join("\n\n"))
	rand(5).times do
		note.tags << Tag.create(tag: Faker::Lorem.words.join(' '))
	end
end