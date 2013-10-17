class Search
  attr_accessor :search_string

  def initialize(search_string)
    @search_string  = search_string
  end

  def notes
    unless search_string.blank?
      found_notes = Note.where query_args 
      sort_by_score found_notes
    else
      Note.all
    end
  end

  private

  def query_args
    where_string = []
    args = []
    search_string.downcase.split.each do |word|
      where_string << '(lower(title) LIKE ? OR lower(text) LIKE ?)'
      args << "%#{word}%"
      args << "%#{word}%"
    end
    [where_string.join(' AND ')] + args
  end

  def score(note)
    score = 0
    search_string.downcase.split.each do |search_word|
      score += note.title.downcase.scan(search_word).size * 5
      score += note.text.downcase.scan(search_word).size
    end
    score
  end

  def sort_by_score notes
    notes.sort! { |a,b| score(a) <=> score(b) }.reverse
  end
end
