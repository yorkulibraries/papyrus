Papyrus::Application.routes.draw do






  get "stats" => "stats#index"
  get "stats/generate" =>"stats#generate"
  get "stats/item_usage" => "stats#item_usage"

  get "dashboard" => "home#index"
  get "active_users" => "home#active_users", as: :active_users

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"


  # Anouncements
  resources :announcements do
    get "hide", on: :member
  end

  # match 'announcements/:id/hide', to: 'announcements#hide', as: 'hide_announcement'


  # Student View
  match "login_as_student/:id" => "student_view#login_as_student", :as => :admin_student_view, via: [:get, :post]
  match "logout_as_student" => "student_view#logout_as_student", :as => :logout_as_student, via: [:get, :post]
  get "my/" => "student_view#show", :as => :student_view
  get "my/details" => "student_view#details", :as => :student_view_details
  match "my/terms" => "student_view#index", :as => :show_student_terms, via: [:get, :post]
  match "my/accept_terms" => "student_view#accept_terms", :as => :accept_student_terms, via: [:get, :post]
  match "my/access_codes" => "student_view#access_codes", as: :student_view_access_codes, via: [:get, :post]

  resources :users do
    post "activate", :on => :member
    get "audit_trail", :on => :member
    get "inactive", :on => :collection
  end

  resources :terms do
     resources :courses do
        post "add_item", :on => :member
        post "assign_to_item", :on => :collection
        post "remove_item", :on => :member
     end
     get "search_courses", :on => :collection
  end

  resources :shared_access_codes, only: [:index, :new, :create, :destroy]

  resources :students do
    resources :access_codes
    resources :notes, except: [:show, :new]

    resource :student_details, as: :details, path: "details", except: [:index, :destroy]

    collection do
      get "inactive"
      get "search"
      post "notify"
    end

    member do
      get 'items'
      post "send_welcome_email"
      get "audit_trail"
      get :block
      get :unblock
      get :reactivate
      get :complete_orientation
    end
  end

  resources :items do
    post 'assign_to_students', :on => :member
    post 'assign_many_to_student', :on => :collection
    delete 'withhold_from_student', :on => :member
    get "courses", :on => :member
    get 'zipped_files', :on => :member
    get 'acquisition_requests', :on => :member
    #get 'search', :on => :collection
    #get 'search_vufind', :on => :collection
    resources :attachments, path: "files", except: [:index, :show] do
      get 'get_file', on: :member
      post 'delete_multiple', on: :collection
    end

  end

  resources :acquisition_requests, :except => [:new, :create] do
    post "fulfill", :on => :member
    get "for_item", :on => :collection
    post "remove_note", :on => :member
  end

  # ITEMS Search
  match "search/items(/:type)" => "search_items#index", as: "search_items", via: :get,  defaults: { type: "local" }

  # Root
  root :to => "home#index"

end
