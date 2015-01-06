class AddFolderRefToNotes < ActiveRecord::Migration
  def change
    add_reference :notes, :folder, index: true
  end
end
