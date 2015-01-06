class Note < ActiveRecord::Base
    belongs_to :user
    belongs_to :folder

    validates_presence_of :title, :message => "is blank"
    validates_presence_of :content, :message => "is blank"
    validates_uniqueness_of :title,:message => "already exists"
end
