PortCalendar::Application.routes.draw do
  devise_for :users
   root :to => 'home#extjs' , :method => :get 
   
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
     put 'confirm_booking_payment' => 'bookings#confirm_booking_payment' , :as => :confirm_booking_payment 
     
     # get 'sales_amount_reports' => 'bookings#sales_amount_reports', :as => :sales_amount_reports
     get 'booking_reports' => 'bookings#booking_reports', :as => :booking_reports
     
     resources :calendars
     resources :customers
     resources :app_users
     
     
     resources :incomes 
     
     
     resources :events 
   end
end


