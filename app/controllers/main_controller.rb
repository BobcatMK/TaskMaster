class MainController < ApplicationController
  layout "application"

  def home
    if !current_user
      respond_to do |format|
        format.html
        format.js { render "home.js.erb" }
      end
    elsif current_user
      respond_to do |format|
        format.html { redirect_to logged_signed_path }
      end
    end
  end

  def ajax_login
    if !current_user
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    elsif current_user
      respond_to do |format|
        format.html { redirect_to logged_signed_path }
      end
    end
  end

  def ajax_signup
    if !current_user
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    elsif current_user
      respond_to do |format|
        format.html { redirect_to logged_signed_path }
      end
    end
  end

  def contact
    @contact = Contact.first
    if !current_user
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { render "contact.js.erb" }
      end
    elsif current_user
      respond_to do |format|
        format.html { redirect_to logged_signed_path }
      end
    end
  end

end
