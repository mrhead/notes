require 'spec_helper'

describe Search, '#search' do
  it 'allows to use more words with arbitrary order in title' do
    note = FactoryGirl.create(:note, title: 'one two three')

    search = Search.new('three one')

    expect(search.notes).to include(note)
  end

  it 'allows to use more words with arbitrary order in text' do
    note = FactoryGirl.create(:note, text: 'one two three')

    search = Search.new('three one')

    expect(search.notes).to include(note)
  end

  it 'uses all provided words (AND instead of OR)' do
    note = FactoryGirl.create(:note, title: 'one two three', text: 'four five six')
    other_note = FactoryGirl.create(:note, title: 'one two', text: 'four five')

    search = Search.new('one three')
    expect(search.notes).to include(note)
    expect(search.notes).not_to include(other_note)

    search = Search.new('four six')
    expect(search.notes).to include(note)
    expect(search.notes).not_to include(other_note)
  end

  it 'is case insensitive' do
    note = FactoryGirl.create(:note, title: 'One', text: 'TwO')

    search = Search.new('OnE')
    expect(search.notes).to include(note)

    search = Search.new('tWo')
    expect(search.notes).to include(note)
  end

  it 'returns all notes when search string is empty' do
    note = FactoryGirl.create(:note)
    other_note = FactoryGirl.create(:note)

    search = Search.new(nil)

    expect(search.notes).to eq [note, other_note]
  end

  it 'orders results according to search score (word in title has higher score)' do
    note_one = FactoryGirl.create(:note, title: 'not relevant', text: 'World hello!')
    note_two = FactoryGirl.create(:note, title: 'Hello world', text: 'not relevant')
    note_three = FactoryGirl.create(:note, title: 'Hello', text: 'world')

    search = Search.new('Hello world')

    expect(search.notes).to eq [note_two, note_three, note_one]
  end
end
