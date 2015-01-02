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
  get "/application/day_view_change_forward/(:year_changer)/(:month_changer)/(:day_changer)",to: "user#day_view_change_forward",as: :day_view_change_forward
  get "/application/day_view_change_backward/(:year_changer)/(:month_changer)/(:day_changer)",to: "user#day_view_change_backward",as: :day_view_change_backward

  # TASK CONTROLLER
  get "/application/start_date/(:date_year)/(:date_month)/(:date_day)",to: "task#start_date",as: :start_date
  get "/application/end_date/(:date_year)/(:date_month)/(:date_day)",to: "task#end_date",as: :end_date
  get "/application/add_task/(:date_year)/(:date_month)/(:date_day)",to: "task#add_task_get", as: :add_task_get
  post "/application/create_task",to: "task#create_task",as: :create_task
  patch "/application/task_completed",to: "task#task_completed",as: :task_completed
  patch "/application/task_edit_get",to: "task#task_edit_get",as: :task_edit_get
  patch "/application/edit_task",to: "task#edit_task",as: :edit_task

    # ROUTES FOR CALENDAR AJAX
    get "/application/change_year_forward/(:date_year)/(:date_month)", to: "task#change_year_forward", as: :change_year_forward
    get "/application/change_year_backward/(:date_year)/(:date_month)",to: "task#change_year_backward", as: :change_year_backward
    get "/application/change_month_forward/(:date_year)/(:date_month)",to: "task#change_month_forward", as: :change_month_forward
    get "/application/change_month_backward/(:date_year)/(:date_month)",to: "task#change_month_backward",as: :change_month_backward

    get "/application/change_year_forward_end/(:date_year)/(:date_month)", to: "task#change_year_forward_end", as: :change_year_forward_end
    get "/application/change_year_backward_end/(:date_year)/(:date_month)",to: "task#change_year_backward_end", as: :change_year_backward_end
    get "/application/change_month_forward_end/(:date_year)/(:date_month)",to: "task#change_month_forward_end", as: :change_month_forward_end
    get "/application/change_month_backward_end/(:date_year)/(:date_month)",to: "task#change_month_backward_end",as: :change_month_backward_end

  # WEEK CONTROLLER
  get "/application/week_view",to: "week#week_view",as: :week_view
  get "/application/add_task_week_view/(:date_year)/(:date_month)/(:date_day)",to: "week#add_task_week_view", as: :add_task_week_view
  post "/application/create_task_week_view",to: "week#create_task_week_view",as: :create_task_week_view
  get "/application/particular_day_tasks/(:year)/(:month)/(:day)",to: "week#particular_day_tasks",as: :particular_day_tasks
  patch "/application/task_edit_get_week_view",to: "week#task_edit_get_week_view",as: :task_edit_get_week_view
  patch "/application/edit_task_week_view",to: "week#edit_task_week_view",as: :edit_task_week_view
  patch "/application/task_completed_week_view",to: "week#task_completed_week_view",as: :task_completed_week_view
  get "/application/week_backward/(:calendar_id)",to: "week#week_backward",as: :week_backward
  get "/application/week_forward/(:calendar_id)",to: "week#week_forward",as: :week_forward
  get "/application/next_seven_days",to: "week#next_seven_days",as: :next_seven_days
  get "/application/next_seven_days_generate_tasks/(:year)/(:month)/(:day)",to: "week#next_seven_days_generate_tasks",as: :next_seven_days_generate_tasks
  get "/application/next_seven_days_add_task_get/(:date_year)/(:date_month)/(:date_day)",to: "week#next_seven_days_add_task_get", as: :next_seven_days_add_task_get
  post "/application/next_seven_days_add_task",to: "week#next_seven_days_add_task",as: :next_seven_days_add_task
  patch "/application/next_seven_days_edit_get",to: "week#next_seven_days_edit_get",as: :next_seven_days_edit_get
  patch "/application/next_seven_days_edit",to: "week#next_seven_days_edit",as: :next_seven_days_edit
  patch "/application/next_seven_days_completed",to: "week#next_seven_days_completed",as: :next_seven_days_completed
  
  # MONTH CONTROLLER
  get "/application/month_view",to: "month#month_view",as: :month_view
  get "/application/month_task_get/(:date_year)/(:date_month)/(:date_day)",to: "month#month_task_get",as: :month_task_get
  post "/application/create_task_month_view",to: "month#create_task_month_view",as: :create_task_month_view
  get "/application/month_backward/(:date_year)/(:date_month)",to: "month#month_backward",as: :month_backward
  get "/application/month_forward/(:date_year)/(:date_month)",to: "month#month_forward",as: :month_forward

  # TASKVIEW CONTROLLER
  get "/application/task_view/(:sort_by)",to: "taskview#task_view",as: :task_view
  get "/application/task_view_unassigned/(:sort_by)",to: "taskview#task_view_unassigned",as: :task_view_unassigned
  get "/application/task_view_all/(:sort_by)",to: "taskview#task_view_all",as: :task_view_all
  patch "/application/task_view_edit_get",to: "taskview#task_view_edit_get",as: :task_view_edit_get
  patch "/application/task_view_edit",to: "taskview#task_view_edit",as: :task_view_edit
  get "/application/task_view_create_get/(:date_year)/(:date_month)/(:date_day)/(:controller_action)",to: "taskview#task_view_create_get",as: :task_view_create_get
  post "application/task_view_create",to: "taskview#task_view_create",as: :task_view_create
  patch "/application/task_view_completed",to: "taskview#task_view_completed",as: :task_view_completed


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
