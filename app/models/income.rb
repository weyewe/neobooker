class Income < ActiveRecord::Base
  attr_accessible :income_source_id, 
                  :income_source_type,
                  :amount ,
                  :case ,
                  :transaction_datetime ,
                  :code
                  
  belongs_to :income_source, :polymorphic => true 
end
