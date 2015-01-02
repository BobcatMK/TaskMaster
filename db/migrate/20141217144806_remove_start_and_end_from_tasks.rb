class RemoveStartAndEndFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :start, :time
    remove_column :tasks, :end, :time
  end
end
