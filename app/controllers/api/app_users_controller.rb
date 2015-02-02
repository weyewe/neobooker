class Api::AppUsersController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = current_office.users.where{
        (is_deleted.eq false) & 
        (
          (name =~  livesearch ) | 
          (email =~  livesearch )
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = current_office.users.where{
        (is_deleted.eq false) & 
        (
          (name =~  livesearch ) | 
          (email =~  livesearch )
        )
        
      }.count
    else
      @objects = current_office.users.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = current_office.users.active_objects.count
    end
    
    
    
    # render :json => { :users => @objects , :total => @total, :success => true }
  end

  def create
    @object = current_office.users.create_by_employee(current_user,  params[:user] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :users => [@object] , 
                        :total => current_office.users.active_objects.count }  
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
    
    @object = current_office.users.find_by_id params[:id] 
    @object.update_by_employee(current_user,  params[:user])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :users => [@object],
                        :total => current_office.users.active_objects.count  } 
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
    @object = current_office.users.find(params[:id])
    @object.delete(current_user)

    if @object.is_deleted
      render :json => { :success => true, :total => current_office.users.active_objects.count }  
    else
      render :json => { :success => false, :total => current_office.users.active_objects.count }  
    end
  end
end
