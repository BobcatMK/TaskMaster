class UserController < ApplicationController

    include ApplicationHelper

    layout "application"

    def logged_signed

        @today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day)
 
        sorting_algorithm_and_initializer

        if current_user
            respond_to do |format|
                format.html
                format.js { render "logged_signed.js.erb" }
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

    def day_view_change_forward
        @day_changer = params[:day_changer].to_i
        @month_changer = params[:month_changer].to_i
        @year_changer = params[:year_changer].to_i

        @today = Calendar.where(:year => @year_changer,:month => @month_changer,:day => @day_changer + 1)

        if @today.empty?
            @month_changer += 1
            @day_changer = 1
            if @month_changer == 13
                @year_changer += 1
                @month_changer = 1
                @day_changer = 1
                if @year_changer == 2031
                    @year_changer = 2030
                    @month_changer = 12
                    @day_changer = 31
                end
            end
            @today = Calendar.where(:year => @year_changer,:month => @month_changer,:day => @day_changer)
        end

        sorting_algorithm_and_initializer

        respond_to do |respond|
            respond.js { render "day_view_change_forward.js.erb" }
        end
    end

    def day_view_change_backward
        @day_changer = params[:day_changer].to_i
        @month_changer = params[:month_changer].to_i
        @year_changer = params[:year_changer].to_i

        @today = Calendar.where(:year => @year_changer,:month => @month_changer,:day => @day_changer - 1)

        if @today.empty?
            @month_changer -= 1
            begin
                @day_changer = DateTime.new(@year_changer,@month_changer,-1).day
            rescue
                nil
            end
            if @month_changer == 0
                @year_changer -= 1
                @month_changer = 12
                @day_changer = DateTime.new(@year_changer,@month_changer,-1).day
                if @year_changer == 2013
                    @year_changer = 2014
                    @month_changer = 1
                    @day_changer = 1
                end
            end
            @today = Calendar.where(:year => @year_changer,:month => @month_changer,:day => @day_changer)
        end

        sorting_algorithm_and_initializer

        respond_to do |respond|
            respond.js { render "day_view_change_backward.js.erb" }
        end
    end

    private

        def contact_form_params
            params.require(:contactform).permit(:name,:email,:content)
        end
end
