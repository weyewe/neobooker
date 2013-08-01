class Calendar < ActiveRecord::Base
  attr_accessible :title, :color, :description 
  has_many :bookings 
  
  validates_presence_of :title, :color 
  
  def self.active_objects
    self.where(:is_deleted => false ) 
  end
  
  def self.create_object( params ) 
    new_object = self.new 
    new_object.title = params[:title]
    new_object.description = params[:description]
    new_object.color = params[:color]
    new_object.save
    
    return new_object 
  end
  
  def update_object( params  ) 
    self.title = params[:title]
    self.description = params[:description]
    self.color = params[:color]
    self.save 
  end
  
  def delete_object
    if self.bookings.count ==  0 
      self.destroy
    else
      self.errors.add(:generic_errors, "Sudah ada booking") 
    end
    
    
    
    
  end
end
