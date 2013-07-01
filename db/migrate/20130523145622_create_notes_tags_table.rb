class CreateNotesTagsTable < ActiveRecord::Migration
  def change
    create_table :notes_tags do |t|
      t.references :note, index: true
      t.references :tag, index: true
    end
  end
end
