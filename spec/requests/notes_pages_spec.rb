  require 'spec_helper'

describe 'Notes pages' do
  subject { page }

  describe 'index page' do
    before {
      visit root_path
    }

    it { should have_selector "input[placeholder='Put your search string here...']" }
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

        describe 'with note with lot of line' do
          thirty_lines = ""
          30.times do |n|
            thirty_lines += "#{n}\n"
          end
          fifteen_lines = ""
          15.times do |n|
            fifteen_lines += "#{n}\n"
          end
          before {
            FactoryGirl.create(:note, title: 'Title', text: thirty_lines)
            FactoryGirl.create(:note, title: 'Title', text: "short text")
            fill_in :search, with: 'Title'
            click_button 'Search'
          }
          it 'should not show whole note text' do
            should_not have_content thirty_lines
          end
          it 'should show just first 20 lines of note text' do
            should have_content "#{fifteen_lines}..."
          end
          it 'should not add ... to short text' do
            should_not have_content "short text..."
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

  describe 'note show page' do
    before {
      visit note_path(note)
    }
    let(:note) { FactoryGirl.create(:note, title: '<h1>Test</h1>', text: "<html>test</html>") }

    describe 'should automatically create html links for URLs' do
      let(:note) { FactoryGirl.create(:note, text: 'Lorem http://www.example.com/ ipsum.') }
      it { should have_link 'http://www.example.com/', href: 'http://www.example.com/' }
    end

    it 'should have edit link' do
      should have_link 'Edit', edit_note_path(note)
    end

    it 'should have delete link' do
      should have_link 'Delete', note_path(note)
    end

    it 'should be able to delete note' do
      expect { click_link 'Delete' }.to change(Note, :count).by(-1)
    end

    it 'should show success message after note deletion' do
      click_link 'Delete'
      should have_content 'Note has been deleted.'
    end

    it 'should filter html characters' do
      should have_selector 'h3', text: '<h1>Test</h1>'
      should have_content '<html>test</html>'
    end

    it 'should show note text as preformated text' do
    	should have_selector 'pre', text: note.text
    end
  end

  describe 'note creation' do
    before {
      visit new_note_path
    }

    it 'should have cancel link' do
      should have_link 'Cancel', notes_path
    end
    
    it 'cancel should redirect to notes path' do
      click_link 'Cancel'
      current_path.should == notes_path
    end

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
    end
  end

  describe 'note update' do
    before {
      visit edit_note_path(note)
    }
    let(:note) { FactoryGirl.create(:note) }

    it 'should have cancel link' do
      should have_link 'Cancel', note_path(note)
    end

    it 'cancel should redirect to note path' do
      click_link 'Cancel'
      current_path.should == note_path(note)
    end

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
      end
    end

    describe 'with same information' do
      before {
        click_button 'Update Note'
        note.reload
      }
      let(:old_note) { note.clone }

      it 'should not change note' do
        note.title.should == old_note.title
        note.text.should == old_note.text
      end
    end
  end
end