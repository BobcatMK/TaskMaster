class Contactform < ActiveRecord::Base
    has_no_table

    column :name, :string
    column :email, :string
    column :content, :string

    validates_presence_of(:name,:message => "can't be blank")
    # validates_presence_of(:email,:message => "Can't be blank")
    validates_presence_of(:content,:message => "can't be blank")
    validates_format_of(:email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i)
    validates_length_of(:content,:maximum => 600,:message => "is too long")
end
