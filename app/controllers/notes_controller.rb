class NotesController < ApplicationController
  def index
    @notes = Note.search(params[:search])
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)
    @note.tags_string = params[:note][:tags_string]

    if @note.save
      redirect_to notes_path, notice: 'Note has been added.'
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def note_params
      params[:note].permit(:title, :text)
    end
end
