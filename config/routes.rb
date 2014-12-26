Rails.application.routes.draw do

  # MAIN CONTROLLER
  root "main#home"
  get "/home",to: "main#home",as: :home
  get "/ajax_login",to: "main#ajax_login",as: :ajax_login
  get "/ajax_signup", to: "main#ajax_signup",as: :ajax_signup
  get "/contact", to: "main#contact", as: :contact

  # USER CONTROLLER
  get "/application",to: "user#logged_signed",as: :logged_signed
  get "/application/contact", to: "user#application_contact", as: :application_contact
  get "/application/send_contact_form",to: "user#send_contact_form",as: :send_contact_form_get
  post "/application/send_contact_form",to: "user#send_contact_form",as: :send_contact_form

  # TASK CONTROLLER
  get "/application/start_date",to: "task#start_date",as: :start_date
  get "/application/end_date",to: "task#end_date",as: :end_date
  get "/application/add_task",to: "task#add_task_get", as: :add_task_get
  post "/application/create_task",to: "task#create_task",as: :create_task

    # ROUTES FOR CALENDAR AJAX
    get "/application/change_year_forward/(:date_year)/(:date_month)", to: "task#change_year_forward", as: :change_year_forward
    get "/application/change_year_backward/(:date_year)/(:date_month)",to: "task#change_year_backward", as: :change_year_backward
    get "/application/change_month_forward/(:date_year)/(:date_month)",to: "task#change_month_forward", as: :change_month_forward
    get "/application/change_month_backward/(:date_year)/(:date_month)",to: "task#change_month_backward",as: :change_month_backward

    get "/application/change_year_forward_end/(:date_year)/(:date_month)", to: "task#change_year_forward_end", as: :change_year_forward_end
    get "/application/change_year_backward_end/(:date_year)/(:date_month)",to: "task#change_year_backward_end", as: :change_year_backward_end
    get "/application/change_month_forward_end/(:date_year)/(:date_month)",to: "task#change_month_forward_end", as: :change_month_forward_end
    get "/application/change_month_backward_end/(:date_year)/(:date_month)",to: "task#change_month_backward_end",as: :change_month_backward_end
  devise_for :users, controllers: { registrations: "customization/registrations",sessions: "customization/sessions" }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
