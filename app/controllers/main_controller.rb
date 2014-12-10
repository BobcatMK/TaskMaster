class MainController < ApplicationController
  def home
  end

  def ajax_login
    respond_to do |format|
        format.html { redirect_to new_user_session_path }
        format.js
    end
  end

  def ajax_signup
    respond_to do |format|
        format.html { redirect_to new_user_registration_path }
        format.js
    end
  end
end
