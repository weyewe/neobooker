class Price < ActiveRecord::Base
  belongs_to :office
  belongs_to :calendar 
  has_many :bookings 
  
  attr_accessible :amount, :is_active , :calendar_id
end
