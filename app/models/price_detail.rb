class PriceDetail < ActiveRecord::Base
  belongs_to :office
  after_create :update_amount 
  belongs_to :price_rule 
  belongs_to :booking 
  
  validates_presence_of :booking_id, :price_rule_id, :number_of_hours
  
  
  def update_amount
    self.amount = self.price_rule.amount * self.number_of_hours
    self.save 
  end
  
  def self.create_object(params)
    new_object = self.new 
    new_object.booking_id  = params[:booking_id]
    new_object.price_rule_id  = params[:price_rule_id]
    new_object.number_of_hours  = params[:number_of_hours]
    
    new_object.save 
  end
end
