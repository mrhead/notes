	require 'spec_helper'

describe 'Notes pages' do
	subject { page }

	describe 'index page' do
		before {
			visit root_path
		}

		it { should have_selector "input[placeholder='Put your search string here...']" }

		it { should have_link "Add note", href: new_note_path }

		describe 'with search string' do
			let(:search_notes) { [] }
			let(:other_notes) { [] }

			before {
				3.times do |n|
					search_notes << FactoryGirl.create(:note, title: "Title ##{n}", text: "Find me ##{n}")
					other_notes << FactoryGirl.create(:note)
				end
			}

			describe 'simple title search' do
				before {
					fill_in :search, with: 'Title'
					click_button 'Search'
				}

				it 'should list searched notes' do
					search_notes.each do |note|
						within("div#note_#{note.id}") do
							should have_content note.title
							should have_content note.text
						end
					end
				end

				it 'should not list other notes' do
					other_notes.each do |note|
						should_not have_content note.title
						should_not have_content note.text
					end
				end
			end

			describe 'simple text search' do
				before {
					fill_in :search, with: 'Find me'
					click_button 'Search'
				}

				it 'should list searched notes' do
					search_notes.each do |note|
						within("div#note_#{note.id}") do
							should have_content note.title
							should have_content note.text
						end
					end
				end

				it 'should not list other notes' do
					other_notes.each do |note|
						should_not have_content note.title
						should_not have_content note.text
					end
				end
			end
		end
	end

	describe 'note creation' do
		before {
			visit new_note_path
		}

		describe 'with invalid information' do
			before {
				click_button 'Create Note'
			}

			it 'should show errors' do
				should have_selector 'div.errors'
			end
		end

		describe 'with valid information' do
			before {
				fill_in 'Title', with: note.title
				fill_in 'Text', with: note.text
				fill_in 'Tags', with: 'TagOne, TAG TWO ,tag three 3'	
			}
			let(:note) { FactoryGirl.build(:note) }

			it 'should change note count' do
				expect { click_button 'Create Note' }.to change(Note, :count).by(1)
			end

			describe 'should show success message' do
				before {
					click_button 'Create Note'
				}
				it { should have_content 'Note has been added.' }
			end

			describe 'should redirect to notes path' do
				before {
					click_button 'Create Note'
				}
				it { current_path.should == notes_path }
			end

			it 'should change tag count' do
				expect { click_button 'Create Note' }.to change(Tag, :count).by(3)
			end

			describe 'should assign tags to new note' do
				before {
					click_button 'Create Note'
					@tags = []
					Note.last.tags.each do |tag|
						@tags << tag.tag
					end
				}
				it { @tags.should == ['tagone', 'tag two', 'tag three 3'] }
			end
		end



	end
end