class Search
  TITLE_BOOST = 5

  attr_reader :search_string

  def initialize(search_string)
    @search_string  = search_string
  end

  def notes
    if search_string.blank?
      Note.all
    else
      search_and_order_notes
    end
  end

  private

  def search_and_order_notes
    sort_by_score(found_notes)
  end

  def found_notes
    Note.where(where_query)
  end

  def where_query
    where_string = []
    args = []
    search_string_words.each do |word|
      where_string << '(lower(title) LIKE ? OR lower(text) LIKE ?)'
      args << "%#{word}%" << "%#{word}%"
    end
    [where_string.join(' AND ')] + args
  end

  def search_string_words
    search_string.downcase.split
  end

  def sort_by_score notes
    notes.sort { |a,b| note_score(a) <=> note_score(b) }.reverse
  end

  def note_score(note)
    score = 0
    search_string.downcase.split.each do |search_word|
      score += note.title.downcase.scan(search_word).size * TITLE_BOOST
      score += note.text.downcase.scan(search_word).size
    end
    score
  end
end
