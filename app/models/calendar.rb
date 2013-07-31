class Calendar < ActiveRecord::Base
  has_many :bookings 
  
  
  def self.create_object( params ) 
    new_object = self.new 
    new_object.title = params[:title]
    new_object.description = params[:description]
    new_object.color = params[:color]
    new_object.save
    
    return new_object 
  end
end
