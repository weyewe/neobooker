class Api::TransactionActivitiesController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = current_office.transaction_activities.where{
        (
          (description =~  livesearch )
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = current_office.transaction_activities.where{
        (
          (description =~  livesearch )
        )
      }.count
      
      # calendar
      
    else
      @objects = current_office.transaction_activities.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = current_office.transaction_activities.count 
    end
    
    
    # render :json => { :transaction_activities => @objects , :total => @total , :success => true }
  end

  def create
    # @object = current_office.transaction_activities.new(params[:transaction_activity])
    params[:transaction_activity][:transaction_datetime] =  parse_date( params[:transaction_activity][:transaction_datetime] )
    @object = current_office.transaction_activities.create_object( params[:transaction_activity], false  )
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
                        :total => current_office.transaction_activities.count }  
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
    @object = current_office.transaction_activities.find(params[:id])
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
                        :total => current_office.transaction_activities.count  } 
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
    @object = current_office.transaction_activities.find_by_id params[:id]
    # add some defensive programming.. current user has role admin, and current_user is indeed belongs to the company 
    @object.confirm   
    
    if @object.errors.size == 0  and @object.is_confirmed? 
      render :json => { :success => true, :total => current_office.transaction_activities.count }  
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
    @object = current_office.transaction_activities.find_by_id params[:id]
    # add some defensive programming.. current user has role admin, and current_user is indeed belongs to the company 
    @object.external_unconfirm   
    
    if @object.errors.size == 0  and @object.is_confirmed? 
      render :json => { :success => true, :total => current_office.transaction_activities.count }  
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
    @object = current_office.transaction_activities.find(params[:id])
    @object.delete_object 

    if ( not @object.persisted?   )  
      render :json => { :success => true, :total => current_office.transaction_activities.count }  
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
      @objects = current_office.transaction_activities.where{ (description =~ query)    
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
    
      @total =   current_office.transaction_activities.where{ (description =~ query)    }.count
    else
      @objects = current_office.transaction_activities.where{ (id.eq selected_id)   
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
    
      @total =   current_office.transaction_activities.where{ (description =~ query)    }.count
    end
    
    
    render :json => { :records => @objects , :total => @objects.count, :success => true }
  end
end
