class RemoveCalendarIdFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :calendar_id, :integer
  end
end
