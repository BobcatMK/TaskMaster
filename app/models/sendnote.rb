class Sendnote < ActiveRecord::Base
    has_no_table

    column :sender_name, :string
    column :receiver_email, :string
    column :sender_email, :string

    validates_presence_of(:sender_name,:message => "is blank")
    validates_format_of(:receiver_email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i)
    validates_format_of(:sender_email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i)
end
