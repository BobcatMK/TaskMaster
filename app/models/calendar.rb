class Calendar < ActiveRecord::Base
    has_many :tasks, dependent: :destroy
end
