class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :current_view, :current_research, :logged_in?, :is_admin?, 
                :current_step, :active_research_tab?

  def current_view
    @current_view
  end

  def current_research
    @current_research
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]  
  end

  def logged_in?
    !!current_user
  end
  
  def is_admin?
    current_user.is_admin
  end

  def require_user
    if !logged_in?
      flash[:danger] = "Ingrese al sistema para realizar esa acción"
      redirect_to login_path
    end
  end

  def require_admin
    if !is_admin?
      flash[:danger] = "Acción restringida con su rol actual"
      redirect_to root_path
    end
  end

  def require_owner(research)
    if current_user.id != research.owner.id
      puts "***** NO ES OWNER"
      flash[:danger] = "Acción permitida solo para el propietario del Protocolo"
      redirect_to root_path
    end
    puts "***** SI ES OWNER"
  end

   def true?(obj)
     obj.to_s == "true"
   end

   def active_research_tab?(research, step, tab)
     if (research.new_record?)
       return tab == 1 ? 'active' : 'disabled'
     else 
       return tab == step ? 'active' : ''
     end
   end

end
