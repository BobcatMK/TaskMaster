class UserController < ApplicationController
    layout "application"

    def logged_signed
        #@full_calendar = Calendar.all
        #@today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day)
        #@tasks = Task.all
        #@this_month = Calendar.all.where(:year => 2030,:month => 12)
        if current_user
            respond_to do |format|
                format.html
            end
        elsif !current_user
            redirect_to root_path
        end
    end

    def application_contact
        @contact = Contact.first
        @contactform = Contactform.new
        if current_user
            respond_to do |format|
                format.js { render "application_contact.js.erb" }
            end
        elsif !current_user
            redirect_to root_path
        end
    end

    def send_contact_form
        @contactform = Contactform.new(contact_form_params)
        if @contactform.valid?
            Mailer.contact_form(@contactform).deliver
            render "send_contact_form_success.js.erb"
        else
            render "send_contact_form_fail.js.erb"
        end
    end

    private

        def contact_form_params
            params.require(:contactform).permit(:name,:email,:content)
        end
end
