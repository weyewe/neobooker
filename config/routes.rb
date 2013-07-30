PortCalendar::Application.routes.draw do
   root :to => 'home#extjs' , :method => :get 
   
   namespace :api do 
     resources :bookings 
     resources :calendars 
   end
end


