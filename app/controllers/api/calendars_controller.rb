class Api::CalendarsController < Api::BaseApiController
  
  def index
     
     # @objects = [{
     #     "cal_id"    => "C1",
     #     "cal_title" => "Home",
     #     "cal_color" => 2
     # },{
     #     "cal_id"    => "C2",
     #     "cal_title" => "Work",
     #     "cal_color" => 22
     # },{
     #     "cal_id"    => "C3",
     #     "cal_title" => "School",
     #     "cal_color" => 7
     # },{
     #     "cal_id"    => "C4",
     #     "cal_title" => "Sports",
     #     "cal_color" => 26
     # }]
     # 
     @objects = current_office.calendars.order("id ASC")
     
     # {
     #      "cal_id"    :"C8",
     #      "cal_title" :"Manga",
     #      "cal_color" :26
     #  }
     
     @total = @objects.length
  end

  def create
    @object = current_office.calendars.create_object( params[:calendar])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :calendars => [@object] , 
                        :total => current_office.calendars.active_objects.count }  
    else
      puts "It is fucking error!!\n"*10
      @object.errors.messages.each {|x| puts x }
      
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
  
  def show
    @object  = current_office.calendars.find params[:id]
    render :json => { :success => true,   
                      :calendar => @object,
                      :total => current_office.calendars.active_objects.count  }
  end

  def update
    @object = current_office.calendars.find(params[:id])
    
    # quick hack for ext-calendar 
    if not current_user.has_role?(:calendars , :update_details)
      # render :json => {:success => false, :access_denied => "Sudah Konfirmasi. Hanya dapat di hapus manager atau admin"}
      render :json => {:success => true, :message => "Good"}
      return 
    end
    
    
    @object.update_object(params[:calendar])
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :calendars => [@object],
                        :total => current_office.calendars.active_objects.count  } 
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
    @object = current_office.calendars.find(params[:id])
    @object.delete_object

    if (( not @object.persisted? )   or @object.is_deleted ) and @object.errors.size == 0
      render :json => { :success => true, :total => current_office.calendars.active_objects.count }  
    else
      render :json => { :success => false, :total => current_office.calendars.active_objects.count, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        } 
      }  
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
      @objects = current_office.calendars.where{  (title =~ query)   & 
                                (is_deleted.eq false )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
    else
      @objects = current_office.calendars.where{ (id.eq selected_id)  & 
                                (is_deleted.eq false )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
    end
    
    
    render :json => { :records => @objects , :total => @objects.count, :success => true }
  end
end
