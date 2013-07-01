class RemoveTagFromNote < ActiveRecord::Migration
  def change
    remove_column :notes, :tag_id, :string
  end
end
