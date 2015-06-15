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
    notes = Note.all

    search_words.each do |word|
      notes = notes.where('lower(title) LIKE :word OR lower(text) LIKE :word', word: "%#{word}%")
    end

    notes
  end

  def search_words
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
