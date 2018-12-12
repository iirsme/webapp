class UsersController < ApplicationController
  before_action :set_current_view
  before_action :set_user, only: [:edit, :update, :show, :destroy]
  before_action :require_user

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    # render plain: params[:user].inspect
    @user = User.new(user_params) 
    if @user.save
      flash[:success] = "Usuario creado satisfactoriamente"
      redirect_to users_path
    else
      render 'new'
    end
  end

  def destroy
    @user.destroy
    flash[:danger] = "Usuario eliminado satisfactoriamente"
    redirect_to users_path
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Usuario actualizado satisfactoriamente"
      redirect_to users_path
    else
      render 'edit'
    end
  end

  private
  def set_current_view
    @current_view = 'users'
  end
  def set_user
    @user = User.find(params[:id])
  end
  def user_params
    params.require(:user).permit(:username, :email, :firstname, :lastname, :password, :is_admin)
  end

end