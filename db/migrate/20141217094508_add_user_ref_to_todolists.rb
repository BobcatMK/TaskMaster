class AddUserRefToTodolists < ActiveRecord::Migration
  def change
    add_reference :todolists, :user, index: true
  end
end
