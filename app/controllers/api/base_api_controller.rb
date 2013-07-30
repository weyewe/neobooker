class Api::BaseApiController < ApplicationController
  respond_to :json
  
  def extjs_error_format( errors ) 
    new_error = {}
    errors.messages.each do |field, messages|
      aggregated_messages = "" 
      
      new_error[field.to_s] = messages.join(' | ')
    end
    
    return new_error 
  end
  
  
  def extract_extensible_date(date_string)# 2013-06-30
    date_array = date_string.split('-').map{|x| x.to_i}
    
    # date = Date.new( date_array[0], date_array[1], date_array[2])
    # return date.to_datetime
    
    datetime = DateTime.new(date_array[0], date_array[1], date_array[2], 0 ,0 ,0) 
    puts "inside extraction.. the datetime: #{datetime}"
    return datetime 
  end
  
  def parse_datetime_from_client( datetime_string)
    date = datetime_string.split("T").first
    time = datetime_string.split("T").last 
    
    date_array = date.split('-').map{|x| x.to_i}
    time_array = time.split(':').map{|x| x.to_i}
    
    datetime = DateTime.new(date_array[0], date_array[1], date_array[2], 
                                time_array[0], time_array[1], time_array[2])
    

    datetime = DateTime.new( date_array[0], 
                              date_array[1], 
                              date_array[2], 
                              time_array[0], 
                              time_array[1], 
                              time_array[2],
                  Rational( UTC_OFFSET , 24) )
                  
                  
    return datetime.utc
  end
  
  def extract_date( date ) 
    if date.nil? or date.length == 0 
      return nil 
    end
    
    date_array = date.split("/")
    
    year  = 0
    month = 0 
    day   = 0
    if date_array.nil? || date_array.length == 0  
    else
      year  = date_array[2].to_i
      month = date_array[1].to_i 
      day   = date_array[0].to_i 
    end
    
    new_date = Date.new( year, month, day)
    return new_date 
  end
  
  def extract_datetime( datetime )
    if datetime.nil? or datetime.length ==0 
      return  nil 
    end
    
    date_array = datetime.split(" ").first 
    # puts "The date_array : #{date_array}"
    date_array = date_array.split('/')
    
    time_array =  datetime.split(" ").last 
    # puts "The time_array : #{time_array}"
    time_array = time_array.split(':')
    
    
    
    year  = 0
    month = 0 
    day   = 0
    if date_array.nil? || date_array.length == 0  
    else
      year  = date_array[2].to_i
      month = date_array[1].to_i 
      day   = date_array[0].to_i 
    end
 
    hour   = 0 
    minute = 0 
    second = 0 
    if time_array.nil? || time_array.length == 0  
    else
      hour    = time_array[0].to_i
      minute  = time_array[1].to_i
      second  = time_array[2].to_i
    end        
              
     
     
    new_datetime = DateTime.new( year, 
                  month, 
                  day, 
                  hour, 
                  minute, 
                  second, 
                  Rational( UTC_OFFSET , 24) )
              
    return new_datetime.getutc 
  end
 
end