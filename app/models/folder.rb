class Folder < ActiveRecord::Base
    has_many :notes, dependent: :destroy
    belongs_to :user

    validates_presence_of :title,:message => "is blank"
    validates_uniqueness_of :title,:message => "already exists"
end
