class MainController < ApplicationController
  layout "visitor"

  def home
    if !current_user
      respond_to do |format|
        format.html { render :home }
        format.js { render "home.js.erb" }
      end
    elsif current_user
      render html: '<a href="/users/sign_out" data-method="delete" rel="nofollow">Log out bitch</a>'.html_safe, :layout => "visitor"
    end
  end

  def ajax_login
    if !current_user
      respond_to do |format|
        format.html { redirect_to new_user_session_path }
        format.js
      end
    elsif current_user
      render html: '<a href="/users/sign_out" data-method="delete" rel="nofollow">Log out bitch</a>'.html_safe, :layout => "visitor"
    end
  end

  def ajax_signup
    if !current_user
      respond_to do |format|
        format.html { redirect_to new_user_registration_path }
        format.js
      end
    elsif current_user
      render html: '<a href="/users/sign_out" data-method="delete" rel="nofollow">Log out bitch</a>'.html_safe, :layout => "visitor"
    end
  end

  def contact
    @contact = Contact.first
    respond_to do |format|
      format.js { render "contact.js.erb" }
    end
  end

end
