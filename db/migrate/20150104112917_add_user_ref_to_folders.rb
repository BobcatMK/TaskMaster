class AddUserRefToFolders < ActiveRecord::Migration
  def change
    add_reference :folders, :user, index: true
  end
end
