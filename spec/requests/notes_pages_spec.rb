	require 'spec_helper'

describe 'Notes pages' do
	subject { page }

	describe 'index page' do
		before {
			visit root_path
		}

		it { should have_selector "input[placeholder='Put your search string here...']" }
		it { should have_link "Home", href: notes_path }
		it { should have_link "Add Note", href: new_note_path }

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
							should have_link "Edit", edit_note_path(note)
							should have_link note.title, note_path(note)
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
				fill_in 'Tags', with: 'TagOne, tagone,TAG TWO ,tag three 3'	
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

			describe 'should redirect to note path' do
				before {
					click_button 'Create Note'
				}
				it { current_path.should == note_path(Note.last) }
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

	describe 'note update' do
		before {
			visit edit_note_path(note)
		}
		let(:note) { FactoryGirl.create(:note_with_tags) }

		describe 'with invalid information' do
			before {
				fill_in 'Title', with: nil
				click_button 'Update Note'
			}
			it 'should display errors' do
				should have_selector 'div.errors'
			end
		end

		describe 'with valid information' do
			before {
				fill_in 'Title', with: 'New Title'
				fill_in 'Text', with: 'New Text'
				fill_in 'Tags', with: 'New Tag 1, New Tag 2'
				click_button 'Update Note'
				note.reload
			}

			it 'should show success message' do
				should have_content 'Note has been updated.'
			end

			it 'should redirect to note page' do
				current_path.should == note_path(note)
			end

			it 'should update note' do
				note.title.should == 'New Title'
				note.text.should == 'New Text'
				tags = []
				note.tags.each do |tag|
					tags << tag.tag
				end
				tags.should == ['new tag 1', 'new tag 2']
			end
		end

		describe 'with same information' do
			before {
				click_button 'Update Note'
				note.reload
			}
			let(:old_note) { note.clone }
			let(:old_tags_string) { note.tags_string }

			it 'should not change note' do
				note.title.should == old_note.title
				note.text.should == old_note.text
				note.tags_string.should == old_tags_string
			end
		end
	end
end