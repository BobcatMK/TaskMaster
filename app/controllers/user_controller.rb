class UserController < ApplicationController
    layout "application"

    def logged_signed
        if current_user
            respond_to do |format|
                format.html
            end
        elsif !current_user
            redirect_to root_path
        end
    end
end
