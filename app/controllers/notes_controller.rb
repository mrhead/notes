class NotesController < ApplicationController
  def index
    @notes = Search.new(params[:search]).notes

    @notes.each(&:truncate_lines)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)

    if @note.save
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
      redirect_to note_path(@note), notice: 'Note has been updated.'
    else
      render 'edit'
    end
  end

  def destroy
    set_note
    @note.destroy
    redirect_to notes_path, notice: 'Note has been deleted.'
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params[:note].permit(:title, :text)
  end
end
