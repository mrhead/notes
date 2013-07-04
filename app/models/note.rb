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
  has_and_belongs_to_many :tags

  validates :title, presence: true

  attr_reader :tags_string
  attr_accessor :form_tags_string

  def self.search(search_string)
  	if search_string
      where_string = []
      args = []
      search_string.split.each do |word|
        where_string << 'title LIKE ? OR text LIKE ?'
        args << "%#{word}%"
        args << "%#{word}%"
      end
  		where args.unshift(where_string.join(' OR '))
  	else
  		[]
  	end
  end

  def update_tags_from_form_tags_string
    tmp_tags_string = form_tags_string

    # as first remove all tags associations (not tags itself)
    tags.each do |tag|
      tags.delete(tag)
    end

    # and assign new ones if there are any
    unless tmp_tags_string.blank?
      tmp_tags_string.downcase.split(',').map { |s| s.strip }.uniq.each do |tag|
        tag.strip!
        tags << Tag.where(tag: tag).first_or_create
      end
    end
  end

  def tags_string(obj = nil)
    tags_array = []
    tags.each do |tag|
      tags_array << tag.tag
    end
    @tags_string = tags_array.join(', ')
  end
end
