Papyrus::Application.routes.draw do
  







 



  match "stats" => "stats#index"
  match "stats/generate" =>"stats#generate"
  
  match "dashboard" => "home#index"
  
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"  
  
  
  
  # Student View
  match "login_as_student/:id" => "student_view#login_as_student", :as => :admin_student_view
  match "logout_as_student" => "student_view#logout_as_student", :as => :logout_as_student
  match "my/" => "student_view#show", :as => :student_view  
  match "my/details" => "student_view#details", :as => :student_view_details
  match "my/terms" => "student_view#index", :as => :show_student_terms
  match "my/accept_terms" => "student_view#accept_terms", :as => :accept_student_terms
  
    
  resources :users do
    post "activate", :on => :member
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

  
  resources :students do
    resources :notes, :except => [:show, :new]
    resource :student_details, :as => :details, :path => "details", :except => [:index, :destroy]
    post 'notify', :on => :collection
    get 'items', :on => :member
    get 'search', :on => :collection
    post "send_welcome_email", :on => :member
    get "audit_trail", :on => :member
    get :block, :on => :member
    get :unblock, :on => :member
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
    resources :attachments, :path => "files", :except => [:index, :show] do
      get 'get_file', :on => :member
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
