class Api::PriceRulesController < Api::BaseApiController
  
  def index
    @parent = Calendar.find_by_id params[:calendar_id]
    @objects = @parent.active_price_rules.joins(:calendar).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_price_rules.count
  end

  def create
   
    @parent = Calendar.find_by_id params[:calendar_id]
    
   
    params[:price_rule][:calendar_id] = @parent.id 
    params[:price_rule][:rule_case] = PRICE_RULE_CASE[:specific]
    @object = PriceRule.create_object(params[:price_rule])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :price_rules => [@object] , 
                        :total => @parent.active_price_rules.count }  
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
    @object = PriceRule.find_by_id params[:id] 
    @parent = @object.calendar 
    
    
    params[:price_rule][:calendar_id] = @parent.id 
    
    @object.update_object( params[:price_rule])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :price_rules => [@object],
                        :total => @parent.active_price_rules.count  } 
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
      render :json => { :success => true, :total => @parent.active_price_rules.count }  
    else
      render :json => { :success => false, :total =>@parent.active_price_rules.count ,
            :message => {
              :errors => extjs_error_format( @object.errors )  
            }
            }  
    end
  end
 
  
 
end
