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
    unless search_string.blank?
      where_string = []
      args = []
      search_string.split.each do |word|
        where_string << '(lower(title) LIKE ? OR lower(text) LIKE ?)'
        word.downcase!
        args << "%#{word}%"
        args << "%#{word}%"
      end
      found_notes = where args.unshift(where_string.join(' AND '))
      found_notes.sort! { |a,b| a.score(search_string) <=> b.score(search_string) }.reverse
    else
      Note.all
    end
  end

  def score(search_string)
    score = 0
    search_string.downcase.split.each do |search_word|
      score += title.downcase.scan(search_word).size * 5
      score += text.downcase.scan(search_word).size
    end
    score
  end
end
