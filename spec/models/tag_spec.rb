# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  tag        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Tag do
	let(:tag) { FactoryGirl.create(:tag) }
	subject { tag }

  it { should respond_to(:notes) }

  it "should have valid factory" do
  	should be_valid
  end
end
