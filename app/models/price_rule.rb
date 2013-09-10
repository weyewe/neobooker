class PriceRule < ActiveRecord::Base
  belongs_to :calendar

  has_many :price_details
  
  validate :hour_start_is_earlier_than_hour_end
  validate :valid_hour_start_and_hour_end
  
  def hour_start_is_earlier_than_hour_end
    return if not hour_start.present? or not  hour_end.present? 
     

    if hour_start > hour_end 
      self.errors.add(:hour_start, "Harus lebih kecil daripada waktu selesai")
      self.errors.add(:hour_end, "Harus lebih besar daripada waktu mulai")
      return self 
    end

      
  end
  
  def valid_hour_start_and_hour_end
    return if not hour_start.present? or not  hour_end.present? 
    
    if hour_start > 23 or hour_start < 0 
      self.errors.add(:hour_start, "Harus diantara 0 sampai 23")
      return self 
    end
    
    if hour_end > 23 or hour_end < 0 
      self.errors.add(:hour_end, "Harus diantara 0 sampai 23")
      return self 
    end
  end
  
  
                  
  def self.create_object(params)
    new_object = self.new 
    
    # puts "The params content:"
    # puts "#{params}"
    new_object.is_sunday      = params[:is_sunday   ] 
    new_object.is_monday      = params[:is_monday   ]
    new_object.is_tuesday     = params[:is_tuesday  ]
    new_object.is_wednesday   = params[:is_wednesday]  
    new_object.is_thursday    = params[:is_thursday  ]
    new_object.is_friday      = params[:is_friday    ]
    new_object.is_saturday    = params[:is_saturday  ]
    new_object.amount         = params[:amount       ]
    new_object.rule_case      = params[:rule_case    ]
    new_object.calendar_id    = params[:calendar_id  ]
    new_object.hour_start    = params[:hour_start  ]
    new_object.hour_end    = params[:hour_end  ]
    
    new_object.save 
    return new_object
  end
  
  def update_object( params )
    if self.rule_case == PRICE_RULE_CASE[:catch_all]
      self.errors.add(:generic_errors, "Catch All rule tidak bisa di edit")
      return self 
    end
    
    if self.price_details.count != 0 
      msg = "Sudah ada booking yang menggunakan harga ini. " + " Silakan delete dan create rule baru"
      self.errors.add(:generic_errors, msg )
      return self 
    end
    
    self.is_sunday      = params[:is_sunday   ] 
    self.is_monday      = params[:is_monday   ]
    self.is_tuesday     = params[:is_tuesday  ]
    self.is_wednesday   = params[:is_wednesday  ]
    self.is_thursday    = params[:is_thursday  ]
    self.is_friday      = params[:is_friday    ]
    self.is_saturday    = params[:is_saturday  ]
    self.amount         = params[:amount       ]
    self.rule_case      = params[:rule_case    ]
    self.calendar_id    = params[:calendar_id  ]
    self.hour_start    = params[:hour_start  ]
    self.hour_end    = params[:hour_end  ]
    
    self.save
    
    return self 
  end
  
  def rule_case_name
    
    if self.rule_case ==  PRICE_RULE_CASE[:catch_all]
  		return  "Catch All"
  	else
  		return "Specific"
  	end
  	
  	
  end
  
  def delete_object  # 
    if self.rule_case == PRICE_RULE_CASE[:catch_all]
      self.errors.add(:generic_errors, "Catch All rule tidak bisa dihapus")
      return self 
    end
    
    self.is_active = false 
    self.deactivated_at = DateTime.now 
    self.save 
  end
  
  def delete_catch_all_rule
    self.is_active = false 
    self.deactivated_at = DateTime.now 
    self.save 
  end
end
