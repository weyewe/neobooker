PortCalendar::Application.routes.draw do
  devise_for :users
   root :to => 'home#extjs' , :method => :get 
   
   
   get '/bookings/confirmation_receipt/:booking_id' => 'bookings#confirmation_receipt', :as => :confirmation_receipt 
   get '/bookings/payment_receipt/:booking_id' => 'bookings#payment_receipt', :as => :payment_receipt
   
   namespace :api do 
     devise_for :users
     
     post 'authenticate_auth_token', :to => 'sessions#authenticate_auth_token', :as => :authenticate_auth_token 
     put 'update_password' , :to => "passwords#update" , :as => :update_password 
     get 'search_role' => 'roles#search', :as => :search_role 
     get 'search_facilities' => 'calendars#search', :as => :search_facilities
     get 'search_customers' => 'customers#search', :as => :search_customers
     
     
     resources :bookings 
     put 'confirm_booking' => 'bookings#confirm' , :as => :confirm_booking 
     put 'pay_booking' => 'bookings#pay' , :as => :pay_booking
     put 'update_booking_start_datetime' => 'bookings#update_start_datetime' , :as => :update_booking_start_datetime 
     put 'update_booking_end_datetime' => 'bookings#update_end_datetime' , :as => :update_booking_end_datetime 
     
     # get 'sales_amount_reports' => 'bookings#sales_amount_reports', :as => :sales_amount_reports
     get 'booking_reports' => 'bookings#booking_reports', :as => :booking_reports
     get 'income_reports' => 'incomes#income_reports', :as => :income_reports
     
     resources :calendars
     resources :customers
     resources :app_users
     
     
     resources :incomes 
     
     
     resources :events 
     resources :price_rules 
   end
end


