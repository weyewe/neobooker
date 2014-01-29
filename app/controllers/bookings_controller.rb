class BookingsController < ApplicationController
  
  # TMU 220 printer : 40 column
  # how can we print text longer than 40?
  # how can we print text less than 40? 
  
  # learn from this: http://stackoverflow.com/questions/2199273/how-to-send-a-dynamically-generated-file-in-a-rails-app
  
  PRINTER_LENGTH = 40 
  def print_centered_line( text ) 
    if text.length > PRINTER_LENGTH
      printed_text = text[0..(PRINTER_LENGTH -1) ]
      return printed_text + "\n" + print_centered_line( text[PRINTER_LENGTH..(text.length-1)])
    else
      extra_space = PRINTER_LENGTH - text.length 
      half_extra_space = extra_space/2 
      return " "*half_extra_space + text  +  "\n"
    end
  end
  
  def print_left_justified_line( text )
    if text.length > PRINTER_LENGTH
      printed_text = text[0..( PRINTER_LENGTH -1) ]
      return printed_text +  "\n" + print_left_justified_line( text[PRINTER_LENGTH..(text.length-1)])
    else
      return text +  "\n"
    end
  end
  
  def print_new_line
    return  "\n"
  end
  
  # max tmeu
  
  def format_datetime_friendly( datetime ) 
    return nil if datetime.nil? 
     
    
    a = datetime.in_time_zone("Jakarta")
    day = a.day
    month = a.month
    year = a.year
    hour = a.hour
    minute = a.min
    second = a.sec 
    
    if day.to_s.length == 1 
      day = "0#{day}"
    end
    
    if month.to_s.length == 1 
      month = "0#{month}"
    end
    
    if hour.to_s.length == 1
      hour  = "0#{hour}"
    end
    
    if minute.to_s.length == 1 
      minute = "0#{minute}"
    end
    
    if second.to_s.length == 1 
      second = "0#{second}"
    end
    
    return "#{year}-#{month}-#{day}" + " " + 
            "#{hour}:#{minute}:#{second}"
  end
  
  def confirmation_receipt
    booking = Booking.find(params[:booking_id])
    if booking.nil?
      redirect_to 'http://google.com'
      return
    end
    
    @start_datetime=  format_datetime_friendly(booking.start_datetime) 
    @end_datetime =  format_datetime_friendly(booking.end_datetime) 
    
    @company = "Robert Futsal"
    @address = "BSD Alam Sutra Block x no xx"
    @phone = "0821 3140 1122"
    @booking = booking 
    
    # content = print_centered_line("Robert Futsal") + 
    #           print_centered_line("BSD Alam Sutra Block x no xx") + 
    #           print_centered_line("Booking: #{booking.booking_code}") + 
    #           print_centered_line("CONFIRM: #{booking.confirmation_code}") + 
    #           print_new_line + print_new_line + 
    #           print_left_justified_line("Field: #{booking.facility.title}") + 
    #           print_left_justified_line("Durasi: #{booking.number_of_hours} jam") + 
    #           print_left_justified_line("  Mulai: #{start_datetime }") + 
    #           print_left_justified_line("  Selesai: #{end_datetime  }") +  
    #           print_left_justified_line("  Jumlah DP: Rp #{booking.downpayment_amount.to_s  }") 
    # send_data content,  :filename => "confirmation_#{booking.booking_code}.txt", :type => 'text'
    render :layout => false
  end
  
  def payment_receipt
    booking = Booking.find(params[:booking_id])
    if booking.nil?
      redirect_to 'http://google.com'
      return
    end
    
    @start_datetime=  format_datetime_friendly(booking.start_datetime) 
    @end_datetime =  format_datetime_friendly(booking.end_datetime) 
    
    @company = "Robert Futsal"
    @address = "BSD Alam Sutra Block x no xx"
    @phone = "0821 3140 1122"
    @booking = booking
  
    # content = print_centered_line("Robert Futsal") + 
    #           print_centered_line("BSD Alam Sutra Block x no xx") + 
    #           print_centered_line("Booking: #{booking.booking_code}") +
    #           print_centered_line("PAYMENT: #{booking.remaining_payment_code}") +  
    #           print_new_line + print_new_line + 
    #           print_left_justified_line("Field: #{booking.facility.title}") + 
    #           print_left_justified_line("Durasi: #{booking.number_of_hours} jam") + 
    #           print_left_justified_line("  Mulai: #{start_datetime }") + 
    #           print_left_justified_line("  Selesai: #{end_datetime  }") +  
    #           print_left_justified_line("  Jumlah Pembayaran: Rp #{booking.remaining_amount.to_s  }")
    # 
    # send_data content,  :filename => "payment_#{booking.booking_code}.txt", :type => 'text'
    
    render :layout => false
  end
end
