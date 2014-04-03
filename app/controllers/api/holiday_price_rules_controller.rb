class Api::HolidayPriceRulesController < Api::BaseApiController
  
  def index
    @parent = Calendar.find_by_id params[:calendar_id]
    @objects = @parent.active_holiday_price_rules.joins(:calendar).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_holiday_price_rules.count
  end

  def create
   
    @parent = Calendar.find_by_id params[:calendar_id]
    params[:holiday_price_rule][:holiday_date] =  parse_date( params[:holiday_price_rule][:holiday_date] )
    
   
    params[:holiday_price_rule][:calendar_id] = @parent.id 
    @object = PriceRule.create_holiday_object(params[:holiday_price_rule])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :holiday_price_rules => [
                            :id => @object.id,
                            :is_holiday => @object.is_holiday,
                            :holiday_date =>format_date_friendly(@object.holiday_date) 
                          ] , 
                        :total => @parent.active_holiday_price_rules.count }  
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg                         
    end
  end

  def update
    params[:holiday_price_rule][:holiday_date] =  parse_date( params[:holiday_price_rule][:holiday_date] )
    
    @object = PriceRule.find_by_id params[:id] 
    @parent = @object.calendar 
    
    
    params[:holiday_price_rule][:calendar_id] = @parent.id 
    
    @object.update_holiday_object( params[:holiday_price_rule])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :holiday_price_rules => [
                            :id => @object.id,
                            :is_holiday => @object.is_holiday,
                            :holiday_date =>format_date_friendly(@object.holiday_date) 
                          ] ,
                        :total => @parent.active_holiday_price_rules.count  } 
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg 
    end
  end

  def destroy
    @object = PriceRule.find(params[:id])
    @parent = @object.calendar 
    @object.delete_object 

    if ( @object.persisted? and not  @object.is_active? ) or ( not @object.persisted? )
      render :json => { :success => true, :total => @parent.active_holiday_price_rules.count }  
    else
      render :json => { :success => false, :total =>@parent.active_holiday_price_rules.count ,
            :message => {
              :errors => extjs_error_format( @object.errors )  
            }
          }  
    end
  end
 
  
 
end
