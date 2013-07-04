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
	let(:note) { FactoryGirl.create(:note) }
	subject { note }

	it { should respond_to(:title) }
	it { should respond_to(:text) }
	it { should respond_to(:tags) }
	it { should respond_to(:tags_string) }

	it_should_be_invalid_without(:title)

	it "should have valid factory" do
  	should be_valid
  end

  describe 'search' do
    let(:note) { FactoryGirl.create(:note, title: 'one two three', text: 'four five six') }

    it 'should allow more words with arbitrary order in title' do
      Note.search('three one').should include(note)
    end

    it 'should allow more words with arbitrary order in text' do
      Note.search('six four').should include(note)
    end

    describe 'should use all provided words' do
      let(:other_note)  { FactoryGirl.create(:note, title: 'one two', text: 'four five') }

      it { Note.search('one three').should include(note) }
      it { Note.search('one three').should_not include(other_note) }
      it { Note.search('four six').should include(note) }
      it { Note.search('four six').should_not include(other_note) }
    end

    it 'should be case insensitive' do
      # this is default on sqlite so tests are passing
      Note.search('SIX').should include(note)
      Note.search('OnE').should include(note)
    end
  end

  describe "tags string" do
  	describe 'should be filled with current tags' do
  		before {
  			@tags = []
  			3.times {
  				tag = FactoryGirl.create(:tag)
  				@tags << tag.tag
  				note.tags << tag
  			}
  		}
  		it { note.tags_string.should == @tags.join(', ') }
  	end


  	describe 'tags should be associated according to tags string' do

  	end
  end
end
