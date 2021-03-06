class Customization::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  include ApplicationHelper

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end


  def edit
    respond_to do |format|
      format.js { render "devise_edit.js.erb" }
      format.html { redirect_to logged_signed_path }
    end
  end

  def create
    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        @today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day)
        sorting_algorithm_and_initializer
        respond_to do |format|
          format.html { redirect_to after_sign_up_path_for(resource) }
          format.js { render "create_success.js.erb" }
        end
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        @today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day)
        sorting_algorithm_and_initializer
        respond_to do |format|
          format.html { redirect_to after_inactive_sign_up_path_for(resource) }
          format.js { render "create_success.js.erb" }
        end
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      respond_to do |format|
        format.html { redirect_to root_path }
        format.xml { render xml: resource }
        format.js { render "create_fail.js.erb" }
      end
    end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      #respond_with resource, location: after_update_path_for(resource)
      respond_to do |format|
        format.js { render "credentials_updated.js.erb" }
      end
    else
      clean_up_passwords resource
      #respond_with resource
      respond_to do |format|
        format.js { render "credentials_not_updated.js.erb" }
      end
    end
  end

end
