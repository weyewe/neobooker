class Api::TransactionActivityEntriesController < Api::BaseApiController
  
  def index
    @parent = TransactionActivity.find_by_id params[:transaction_activity_id]
    @objects = @parent.transaction_activity_entries.joins(:account).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.transaction_activity_entries.count
  end

  def create
    @parent = TransactionActivity.find_by_id params[:transaction_activity_id]
    
    params[:transaction_activity_entry][:transaction_activity_id] = @parent.id 
    @object = TransactionActivityEntry.create_object(params[:transaction_activity_entry])
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :transaction_activity_entries => [@object] , 
                        :total => @parent.transaction_activity_entries.count }  
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
    @object = TransactionActivityEntry.find_by_id params[:id] 
    @parent = @object.calendar 
    
    
    params[:transaction_activity_entry][:transaction_activity_id] = @parent.id 
    
    @object.update_object( params[:transaction_activity_entry])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :transaction_activity_entries => [@object],
                        :total => @parent.transaction_activity_entries.count  } 
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
    @object = TransactionActivityEntry.find(params[:id])
    @parent = @object.transaction_activity 
    @object.delete_object 

    if  not @object.persisted? 
      render :json => { :success => true, :total => @parent.transaction_activity_entries.count }  
    else
      render :json => { :success => false, :total =>@parent.transaction_activity_entries.count ,
            :message => {
              :errors => extjs_error_format( @object.errors )  
            }
          }  
    end
  end
 
  
 
end
