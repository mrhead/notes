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
  validates :title, presence: true

  def self.search(search_string)
  	if search_string
      where_string = []
      args = []
      search_string.split.each do |word|
        where_string << '(lower(title) LIKE ? OR lower(text) LIKE ?)'
        word.downcase!
        args << "%#{word}%"
        args << "%#{word}%"
      end
  		where args.unshift(where_string.join(' AND '))
  	else
  		[]
  	end
  end
end
