class RemoveNotesTagsTable < ActiveRecord::Migration
  def change
    drop_table :notes_tags
  end
end
