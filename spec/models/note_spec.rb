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

  describe 'search method' do
    let(:note) { FactoryGirl.create(:note, title: 'one two three', text: 'four five six') }

    it 'should search more words with arbitrary order in title' do
      Note.search('three one').should include(note)
    end

    it 'should search more words with arbitrary order in text' do
      Note.search('six four').should include(note)
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
