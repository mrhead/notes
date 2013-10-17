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

  it "is invalid without title" do
    note = FactoryGirl.build(:note, title: nil)

    expect(note).to be_invalid
  end

  it "has valid factory" do
    note = FactoryGirl.build(:note)

    expect(note).to be_valid
  end
end
