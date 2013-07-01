# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tag do |t|
    t.sequence(:tag) { |n| "My Tag ##{n}" }
  end

  factory :note do
    title "MyString"
    text "MyText"
    #factory :note_with_tags do
#    	FactoryGirl.create_list(:tag, 3)
    #end
  end
end
