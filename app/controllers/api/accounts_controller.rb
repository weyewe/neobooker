class Api::AccountsController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = Account.where{
        (is_deleted.eq false) & 
        (
          (name =~  livesearch )
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Account.where{
        (is_deleted.eq false) & 
        (
          (name =~  livesearch )
        )
      }.count
      
      # calendar
      
    else
      @objects = Account.active_accounts.where(:depth => 0).order("id ASC")
      @total = @objects.count 
    end
    
    
    # render :json => { :accounts => @objects , :total => @total , :success => true }
  end
  
  def show
    @object = Account.find_by_id params[:id]
    
    @objects = @object.children
    @total = @objects.count 
    
    # render :json => { :accounts => @objects , :total => @total , :success => true }
  end

  def create
    # @object = Account.new(params[:account])
 
    @object = Account.create_object( params[:account] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :accounts => [@object] , 
                        :total => Account.active_objects.count }  
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors ) 
          # :errors => {
          #   :name => "Nama tidak boleh bombastic"
          # }
        }
      }
      
      render :json => msg                         
    end
  end

  def update
    @object = Account.find(params[:id])
    
    @object.update_object( params[:account] )
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :accounts => [@object],
                        :total => Account.active_objects.count  } 
    else
      msg = {
        :success => false, 
        :message => {
          :errors => {
            :name => "Nama tidak boleh kosong"
          }
        }
      }
      
      render :json => msg 
    end
  end

  def destroy
    @object = Account.find(params[:id])
    @object.delete_object 

    if ( not @object.persisted?  or @object.is_deleted ) and @object.errors.size == 0 
      render :json => { :success => true, :total => Account.active_objects.count }  
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
      @objects = Account.where{ (name =~ query)   & 
                                (is_deleted.eq false )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
    else
      @objects = Account.where{ (id.eq selected_id)  & 
                                (is_deleted.eq false )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
    end
    
    
    render :json => { :records => @objects , :total => @objects.count, :success => true }
  end
end
