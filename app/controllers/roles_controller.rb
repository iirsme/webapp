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
    # render plain: params[:role].inspect
    @role = Role.new(role_params) 
    if @role.save
      flash[:success] = "Rol creado satisfactoriamente"
      redirect_to roles_path
    else
      render 'new'
    end
  end

  def show
  end

  def destroy
    @role.destroy
    flash[:success] = "Rol eliminado satisfactoriamente"
    redirect_to roles_path
  end

  def edit
  end

  def update
    if @role.update(role_params)
      flash[:success] = "Rol actualizado satisfactoriamente"
      redirect_to roles_path
    else
      render 'edit'
    end
  end

  private
    def set_current_view
      @current_view = 'roles'
    end
    def set_role
      @role = Role.find(params[:id])
    end
    def role_params
      params.require(:role).permit(:name, :description, :can_create, :can_read, :can_update, :can_delete)
    end
end