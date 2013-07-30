PortCalendar::Application.routes.draw do
  devise_for :users
   root :to => 'home#extjs' , :method => :get 
   
   namespace :api do 
     devise_for :users
     
     post 'authenticate_auth_token', :to => 'sessions#authenticate_auth_token', :as => :authenticate_auth_token 
     put 'update_password' , :to => "passwords#update" , :as => :update_password 
     
     resources :bookings 
     resources :calendars 
   end
end


