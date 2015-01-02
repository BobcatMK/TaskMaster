class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.integer :year
      t.integer :month
      t.integer :day

      t.timestamps
    end
  end
end
