class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :fullname
      t.string :email
      t.string :phone
      t.string :facebook
      t.string :twitter
      t.string :github

      t.timestamps
    end
  end
end
