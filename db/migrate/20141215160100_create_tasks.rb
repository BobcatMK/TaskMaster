class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.text :description
      t.time :start
      t.time :end
      t.boolean :completed
      t.belongs_to :todolist, index: true
      t.belongs_to :calendar, index: true
      t.belongs_to :user, index: true,:unique => true,:null => false

      t.timestamps
    end
  end
end
