# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  text       :text
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Note do
  it "responds to title" do
    expect(Note.new).to respond_to(:title)
  end

  it "responds to text" do
    expect(Note.new).to respond_to(:text)
  end

  it "respond to score" do
    expect(Note.new).to respond_to(:score)
  end

  it "is invalid without title" do
    note = FactoryGirl.build(:note, title: nil)
    expect(note).to be_invalid
  end
	
  it "has valid factory" do
    note = FactoryGirl.build(:note)
    expect(note).to be_valid
  end

  it "counts score for search string" do
    note = FactoryGirl.build(:note, title: 'HellO', text: 'wOrlD!')
    expect(note.score('HELLO')).to eq 5
    expect(note.score('HELLO WORLD')).to eq 6
    expect(note.score('world')).to eq 1
  end

  describe 'search' do
    it 'allows to use more words with arbitrary order in title' do
      note = FactoryGirl.create(:note, title: 'one two three')
      expect(Note.search('three one')).to include(note)
    end

    it 'allows to use more words with arbitrary order in text' do
      note = FactoryGirl.create(:note, text: 'one two three')
      expect(Note.search('three one')).to include(note)
    end

    it 'uses all provided words (AND instead of OR)' do
      note = FactoryGirl.create(:note, title: 'one two three', text: 'four five six')
      other_note = FactoryGirl.create(:note, title: 'one two', text: 'four five')

      expect(Note.search('one three')).to include(note)
      expect(Note.search('one three')).not_to include(other_note)
      expect(Note.search('four six')).to include(note)
      expect(Note.search('four six')).not_to include(other_note)
    end

    it 'is case insensitive' do
      # this is default on sqlite so tests are passing
      note = FactoryGirl.create(:note, title: 'one', text: 'two')
      expect(Note.search('OnE')).to include(note)
      expect(Note.search('tWo')).to include(note)
    end

    it 'returns all notes when search string is empty' do
      note = FactoryGirl.create(:note)
      other_note = FactoryGirl.create(:note)
      notes_search = Note.search('')
      expect(notes_search).to include(note)
      expect(notes_search).to include(other_note)
      expect(notes_search.count).to eq(2)
    end

    it 'orders results according to search score (word in title has higher score)' do
      note_one = FactoryGirl.create(:note, title: 'not relevant', text: 'World hello!')
      note_two = FactoryGirl.create(:note, title: 'Hello world', text: 'not relevant')
      note_three = FactoryGirl.create(:note, title: 'Hello', text: 'world')

      expect(Note.search('Hello world')).to eq [note_two, note_three, note_one]
    end
  end
end
