class UserController < ApplicationController
    layout "user"

    def test
        if current_user
            render html: "<div>AAAAAAAAAAAALE JAJA</div>".html_safe
        elsif !current_user
            redirect_to root_path
        end
    end
end
