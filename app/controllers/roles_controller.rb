class RolesController < ApplicationController
  before_action :set_current_view
  before_action :set_role, only: [:edit, :update, :show, :destroy]
  before_action :require_user

  def index
    @roles = Role.all
  end
  
  def new
    @role = Role.new
  end
  
  def create
    
  end
  
  def show
  end
  
  def destroy
    @role.destroy
    flash[:danger] = "Rol borrado satisfactoriamente"
    redirect_to roles_path
  end
  
  def edit
  end
  
  def update
    
  end
  
  private
    def set_current_view
      @current_view = 'roles'
    end
    def set_role
      @role = Role.find(params[:id])
    end
end