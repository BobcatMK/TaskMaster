class Task < ActiveRecord::Base
  belongs_to :todolist
  belongs_to :calendar
  belongs_to :user
end
