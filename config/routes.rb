Papyrus::Application.routes.draw do


  ## API V1 routes
  namespace :api do
    namespace :v1 do
      concern :information do
        get :info, on: :collection
      end

      get :info, to: "base#info", defaults: { format: 'text' }
      get :login_test, to: "base#test"

      resources :users, concerns: :information, defaults: { format: 'text' }
      resources :items, concerns: :information, defaults: { format: 'text' } # NOT IMPLEMENTED
      resources :courses, concerns: :information, defaults: { format: 'text' } # NOT IMPLEMENTED

    end
  end

  namespace :my do
    resource :terms
    resource :details
    resource :items
    resource :access_codes

    get :welcome, to: "base#welcome", as: "student_portal"
    get :review_details, to: "base#review_details", as: "review_details"

    scope :api do
      get "sync_courses" => "course_sync#sync"
      get "login_as_student/:id", to: "api#login_as_student", as: "login_as_student"
      get "logout_as_student", to: "api#logout_as_student"
    end
  end


  namespace :students do
    get 'permanent_delete/destroy'
    resource :lab_access_only, only: [:show, :destroy], controller: "lab_access_only"

    scope :list do
      get :never_logged_in, to: "list#never_logged_in"
      get :inactive, to: "list#inactive"
      get :blocked, to: "list#blocked"
    end

  end

  get "stats" => "stats#index"
  get "stats/assigned_students" =>"stats#assigned_students"
  get "stats/item_usage" => "stats#item_usage"
  get "stats/items_history" => "stats#items_history"

  get "dashboard" => "home#index"
  get "active_users" => "home#active_users", as: :active_users

  get "logout" => "login#destroy", :as => "logout"
  get "login" => "login#new", :as => "login"

  scope "/find" do
    resources :local_items, only: [:new, :index], module: "search", as: "find_items"
    resource :omni, only: [:new, :show], module: "search", controller: "omni", as: "omni_search"
  end


  # Todo List & Items
  resources :todo_lists do
    resources :todo_items, except: :index
  end

  resource :settings, only: [:update] do
    get :general
    get :email
    get :bib_search
    get :item
    get :system
    get :acquisitions
    get :courses
    get :students

    get :primo_alma
  end

  # Anouncements
  resources :announcements do
    get "hide", on: :member
    resource :activation, only: [:update, :destroy], controller: "announcements/activation"
  end

  # match 'announcements/:id/hide', to: 'announcements#hide', as: 'hide_announcement'
  # Download document link
  get "documents/download/:id" => "documents#download", as: :download_document



  resources :users do
    post "activate", :on => :member
    get "audit_trail", :on => :member
    get "inactive", :on => :collection
  end

  ## Special path for documents to work across the board
  resources :courses do
    resources :documents, path: "syllabus"
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

  namespace :students do
    resources :permanent_delete, only: [:index, :show, :destroy]
  end

  resources :students do
    resources :documents
    resources :access_codes
    resources :notes, except: [:show, :new]

    resource :student_details, as: :details, path: "details", except: [:index, :destroy]

    resource :bulk_renew_items, only: [:new, :create, :show], module: "students"
    resource :expired_items, only: :show, module: "students"

    collection do
      #get "inactive"
      #get "search"
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

      post :enroll_in_courses
      delete :withdraw_from_course
    end
  end

  resources :items do
    get 'renew_access', on: :member
    post 'assign_to_students', on: :member
    post 'assign_many_to_student', on: :collection
    delete 'withhold_from_student', on: :member
    get "courses", on: :member
    get "audit_trail", on: :member
    get 'zipped_files', on: :member
    get 'acquisition_requests', on: :member
    get 'todo_lists', on: :member
    #get 'search', :on => :collection
    #get 'search_vufind', :on => :collection
    resources :attachments, path: "files", except: [:index, :show] do
      get 'get_file', on: :member
      post 'delete_multiple', on: :collection
    end


    collection do
      resources :course_kits, except: [:destroy], module: :items
      resources :from_primo, only: [:index, :new, :create], module: :items
      resources :from_worldcat, only: [:index, :new, :create], module: :items
    end
  end

  resources :acquisition_requests do
    patch :change_status, on: :member
    get :change_status_form, on: :member
    post :send_to_acquisitions, on: :member
    get :status, on: :collection
  end

  # Search

  match "search/items(/:type)" => "search#items", as: "search_items", via: [:get, :post]#,  defaults: { type: "local" }
  match "search/students(/:type)" => "search#students", as: "search_students", via: :get,  defaults: { type: "active" }
  match "search" => "search#index", as: "search", via: :get
  # Root
  root :to => "home#index"

end
