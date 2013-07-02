class NotesController < ApplicationController
  def index
    @notes = Note.search(params[:search])
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)

    if @note.save
      update_tags
      redirect_to note_path(@note), notice: 'Note has been added.'
    else
      render 'new'
    end
  end

  def show
    set_note
  end

  def edit
    set_note
  end

  def update
    set_note
  
    if @note.update(note_params)
      update_tags
      redirect_to note_path(@note), notice: 'Note has been updated.'
    else
      render 'edit'
    end
  end

  def destroy
  end

  private
    def update_tags
      @note.form_tags_string = params[:note][:tags_string]
      @note.update_tags_from_form_tags_string
    end

    def set_note
      @note = Note.find(params[:id])
    end

    def note_params
      params[:note].permit(:title, :text)
    end
end
