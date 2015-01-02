class Mailer < ActionMailer::Base
    default from: "matthew.kilan@gmail.com"

    def contact_form(user)
        @user = user
        mail(to: "matthew.kilan@gmail.com",subject: "You have message from TaskMaster's contact form")
    end
end
