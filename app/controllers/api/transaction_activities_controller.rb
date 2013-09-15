class Api::TransactionActivitiesController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = TransactionActivity.where{
        (is_deleted.eq false) & 
        (
          (name =~  livesearch )
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = TransactionActivity.where{
        (is_deleted.eq false) & 
        (
          (name =~  livesearch )
        )
      }.count
      
      # calendar
      
    else
      @objects = TransactionActivity.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = TransactionActivity.count 
    end
    
    
    # render :json => { :transaction_activities => @objects , :total => @total , :success => true }
  end

  def create
    # @object = TransactionActivity.new(params[:transaction_activity])
    params[:transaction_activity][:transaction_datetime] =  parse_date( params[:transaction_activity][:transaction_datetime] )
    @object = TransactionActivity.create_object( params[:transaction_activity], false  )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :transaction_activities => [
                          {
                            :id 						 =>	@object.id,                                               
                          	:transaction_datetime  =>	format_date_friendly(@object.transaction_datetime),
                          	:transaction_source_type => @object.transaction_source_type, 
                          	:transaction_source_id 					 =>	@object.transaction_source_id,
                          	:description 		 =>	@object.description,
                          	:amount 		 =>	@object.amount,
                          	:is_confirmed 		 =>	@object.is_confirmed
                          }
                          ] , 
                        :total => TransactionActivity.count }  
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
    @object = TransactionActivity.find(params[:id])
    params[:transaction_activity][:transaction_datetime] =  parse_date( params[:transaction_activity][:transaction_datetime] )
    @object.update_object( params[:transaction_activity], false  )
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :transaction_activities => [
                            {
                              :id 						 =>	@object.id,                                               
                            	:transaction_datetime  =>	format_date_friendly(@object.transaction_datetime),
                            	:transaction_source_type => @object.transaction_source_type, 
                            	:transaction_source_id 					 =>	@object.transaction_source_id,
                            	:description 		 =>	@object.description,
                            	:amount 		 =>	@object.amount,
                            	:is_confirmed 		 =>	@object.is_confirmed
                            }
                            
                          ],
                        :total => TransactionActivity.count  } 
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
  
  
  def confirm
    @object = TransactionActivity.find_by_id params[:id]
    # add some defensive programming.. current user has role admin, and current_user is indeed belongs to the company 
    @object.confirm   
    
    if @object.errors.size == 0  and @object.is_confirmed? 
      render :json => { :success => true, :total => TransactionActivity.count }  
    else
      # render :json => { :success => false, :total => Delivery.active_objects.count } 
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg 
    end
  end
  
  def unconfirm
    @object = TransactionActivity.find_by_id params[:id]
    # add some defensive programming.. current user has role admin, and current_user is indeed belongs to the company 
    @object.external_unconfirm   
    
    if @object.errors.size == 0  and @object.is_confirmed? 
      render :json => { :success => true, :total => TransactionActivity.count }  
    else
      # render :json => { :success => false, :total => Delivery.active_objects.count } 
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
    @object = TransactionActivity.find(params[:id])
    @object.delete_object 

    if ( not @object.persisted?   )  
      render :json => { :success => true, :total => TransactionActivity.count }  
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
  
  
  def search
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      @objects = TransactionActivity.where{ (description =~ query)    
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
    
      @total =   TransactionActivity.where{ (description =~ query)    }.count
    else
      @objects = TransactionActivity.where{ (id.eq selected_id)   
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
    
      @total =   TransactionActivity.where{ (description =~ query)    }.count
    end
    
    
    render :json => { :records => @objects , :total => @objects.count, :success => true }
  end
end
