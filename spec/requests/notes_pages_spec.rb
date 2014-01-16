require 'spec_helper'

describe 'Notes pages' do
  describe 'index page' do
    it 'has all needed html elements' do
      visit notes_path

      expect(page).to have_selector "input[placeholder='Put your search string here...']"
      expect(page).to have_link "Add Note", href: new_note_path 
    end

    it 'lists all notes' do
      note = FactoryGirl.create(:note, title: 'Hello', text: 'world!')

      visit notes_path

      expect(page).to have_link note.title, href: note_path(note)
      expect(page).to have_content note.text
    end

    describe 'with long text in notes' do
      it 'shows just first 15 lines of note text' do
        note = FactoryGirl.create(:note, text: "Text\n" * 20)

        visit notes_path

        expect(page).not_to have_content note.text
        expect(page).to have_content "Text\n" * 15 + "..."
      end

      it "doesn't add ... to short notes" do
        FactoryGirl.create(:note, text: "Hello")

        visit notes_path

        expect(page).not_to have_content "Hello..."
      end
    end

    describe 'with search string' do
      it 'lists all found notes' do
        note = FactoryGirl.create(:note, title: 'Hello', text: 'world!')
        other_note = FactoryGirl.create(:note, title: 'Not relevant', text: 'Not relevant')

        visit notes_path
        fill_in :search, with: 'Hello'
        click_button 'Search'

        expect(page).to have_link note.title, href: note_path(note)
        expect(page).to have_content note.text
        expect(page).not_to have_content other_note.text
      end

      it 'provides instant search (ajax)', js: true do
        note = FactoryGirl.create(:note, title: 'Hello', text: 'world!')
        other_note = FactoryGirl.create(:note, title: 'Not relevant', text: 'Not relevant')

        visit note_path(other_note)
        fill_in :search, with: 'Hello'

        expect(page).to have_content note.text
        expect(page).not_to have_content other_note.text

        fill_in :search, with: ""
        page.execute_script('$("#search").trigger("keyup")')

        expect(page).not_to have_content note.text
        expect(page).to have_content other_note.text             
      end
    end


  end

  describe 'show page' do
    it 'automatically creates html links for URLs' do
      note = FactoryGirl.create(:note, text: 'Lorem http://www.example.com/ ipsum.')

      visit note_path(note)

      expect(page).to have_link 'http://www.example.com/', href: 'http://www.example.com/'
    end

    it 'has all needed controls' do
      note = FactoryGirl.create(:note)

      visit note_path(note)

      expect(page).to have_link 'Edit', edit_note_path(note)
      expect(page).to have_link 'Delete', note_path(note)
    end

    it 'deletes note after click on Delete button' do
      note = FactoryGirl.create(:note)

      visit note_path(note)

      expect { click_link 'Delete' }.to change(Note, :count).by(-1)
    end

    it 'shows success message after note deletion' do
      note = FactoryGirl.create(:note)

      visit note_path(note)
      click_link 'Delete'

      expect(page).to have_content 'Note has been deleted.'
    end

    it 'escapes html characters' do
      note = FactoryGirl.create(:note, title: '<h1>Test</h1>', text: "<html>test</html>")

      visit note_path(note)

      expect(page).to have_selector 'h3', text: '<h1>Test</h1>'
      expect(page).to have_content '<html>test</html>'
    end

    it 'shows note text as preformated text' do
      note = FactoryGirl.create(:note)

      visit note_path(note)

      expect(page).to have_selector 'pre', text: note.text
    end
  end

  describe 'new note page' do
    it 'has cancel link' do
      visit new_note_path

      expect(page).to have_link 'Cancel', notes_path
    end

    describe 'creation with invalid information' do
      it 'shows errors' do
        visit new_note_path
        click_button 'Create Note'

        expect(page).to have_selector 'div.errors'
      end

      it "doesn't create new note" do
        visit new_note_path

        expect { click_button 'Create Note' }.not_to change(Note, :count)
      end
    end

    describe 'creation with valid information' do
      it 'creates new note' do
        visit new_note_path
        fill_in 'Title', with: "Hello"

        expect { click_button 'Create Note' }.to change(Note, :count).by(1)
      end

      it 'shows success message' do
        visit new_note_path
        fill_in 'Title', with: "Hello"
        click_button 'Create Note'

        expect(page).to have_content 'Note has been added.'
      end

      it 'redirects to note path' do
        visit new_note_path
        fill_in 'Title', with: "Hello"
        click_button 'Create Note'

        expect(page.current_path).to eq note_path(Note.last)
      end
    end
  end

  describe 'edit note page' do
    it 'has cancel link' do
      note = FactoryGirl.create(:note)
      visit edit_note_path(note)

      expect(page).to have_link 'Cancel', note_path(note)
    end

    describe 'note update with invalid information' do
      it 'displays errors' do
        note = FactoryGirl.create(:note)

        visit edit_note_path(note)
        fill_in 'Title', with: nil
        click_button 'Update Note'

        expect(page).to have_selector 'div.errors'
      end
    end

    describe 'note update with valid information' do
      it 'updates note' do
        note = FactoryGirl.create(:note, title: 'Hello', text: 'world!')

        visit edit_note_path(note)
        fill_in 'Title', with: 'Lorem'
        fill_in 'Text', with: 'ipsum'
        click_button 'Update Note'
        note.reload

        expect(note.title).to eq 'Lorem'
        expect(note.text).to eq 'ipsum'
      end

      it 'shows success message' do
        note = FactoryGirl.create(:note)

        visit edit_note_path(note)
        click_button 'Update Note'

        expect(page).to have_content 'Note has been updated.'
      end

      it 'redirects to note page' do
        note = FactoryGirl.create(:note)

        visit edit_note_path(note)
        click_button 'Update Note'

        current_path.should == note_path(note)
      end
    end
  end
end
