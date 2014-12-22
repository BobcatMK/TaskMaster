class CreateJoinTableTaskCalendar < ActiveRecord::Migration
  def change
    create_join_table :tasks, :calendars do |t|
      t.index [:task_id, :calendar_id]
      t.index [:calendar_id, :task_id]
    end
  end
end
