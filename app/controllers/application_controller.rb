class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :current_view, :current_research, :logged_in?, :is_admin?, 
                :current_step, :active_research_tab?,
                :is_research_user?,
                :is_super_admin?

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

  def is_super_admin?
    current_user.username == 'system.admin'
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

  def require_admin_or_account_owner(user_account)
    if !is_admin? && user_account.id != current_user.id
      flash[:danger] = "Acción restringida con su rol/usuario actual"
      redirect_to root_path
    end
  end

  def require_owner(research)
    if is_super_admin?
      return;
    end
    if current_user.id != research.owner.id
      flash[:danger] = "Acción permitida solo para el propietario del Protocolo"
      redirect_to root_path
    end
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

  def is_research_user?(research)
    research.research_users.each do |ru|
      if ru.user.id == current_user.id
        return true
      end
    end
    return false
  end

  def require_research_user(research)
    if is_super_admin?
      return;
    end
    if !is_research_user?(research)
      flash[:danger] = "Acción permitida solo para usuarios del Protocolo"
      redirect_to root_path
    end
  end

  def is_number? string
    true if Float(string) rescue false
  end

end
