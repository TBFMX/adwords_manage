AdwordsOnRails::Application.routes.draw do
  resources :adds


  get "home/index"

  controller  :campaign do

   get "campaign/index"
   get "campaign/list"
   get "campaign/new" => :new 
   post "campaign/new" => :create
  end
  #resources :account
controller :account do
  get "account/index" => :index
  get "account/input" => :input
  get "account/select" => :select
  get "account/new" => :new
  post "account/create" => :create
end

  get "adds/new", :as => "new_add"
  get "account/index"
  get "account/input"
  get "account/select"
  get "account/new"
  post "account/create"

  get "login/prompt"
  get "login/callback"
  get "login/logout"

  get "report/index"
  post "report/get"



  root :to => "home#index"
end
