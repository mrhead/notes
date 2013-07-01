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

class Note < ActiveRecord::Base
  has_and_belongs_to_many :tags, after_add: :initialize_tags_string, after_remove: :initialize_tags_string

  validates :title, presence: true

  attr_accessor :tags_string

  after_save :update_tags_from_string
  after_find :initialize_tags_string

  def self.search(search_string)
  	if search_string
  		where 'title LIKE ? OR text LIKE ?', "%#{search_string}%", "%#{search_string}%"
  	else
  		[]
  	end
  end

  private
  	def update_tags_from_string
  		# as first remove all tags associations (not tags itself)
  		tags.each do |tag|
  			tags.delete(tag)
  		end

  		# and assign new ones if there are any
  		unless tags_string.blank?
  			tags_string.downcase.split(',').each do |tag|
  				tag.strip!
  				tags << Tag.where(tag: tag).first_or_create
  			end
  		end
  	end

    def initialize_tags_string(obj = nil)
      tags_array = []
      tags.each do |tag|
        tags_array << tag.tag
      end
      @tags_string = tags_array.join(', ')
    end
end
