class AddStartAndEndToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :start, :datetime
    add_column :tasks, :end, :datetime
  end
end
