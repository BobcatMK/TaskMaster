class Task < ActiveRecord::Base
  belongs_to :todolist
  has_and_belongs_to_many :calendars
  belongs_to :user

  validates_presence_of :description
end
