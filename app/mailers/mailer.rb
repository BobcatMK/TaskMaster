class Mailer < ActionMailer::Base
    default from: "matthew.kilan@gmail.com"

    def contact_form(user)
        @user = user
        mail(to: "matthew.kilan@gmail.com",subject: "You have message from TaskMaster's contact form")
    end

    def send_note_via_email(sendnote,this_note)
        @sendnote = sendnote
        @this_note = this_note
        mail(:to => @sendnote.receiver_email,subject: "#{@sendnote.sender_email} sends you note")
    end
end
