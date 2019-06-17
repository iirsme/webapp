class FieldsController < ApplicationController
  before_action :set_current_view
  before_action :set_role, only: [:edit, :update, :show, :destroy]
  before_action :require_user
  before_action :require_admin

  def index
    @fields = Field.all
  end

  def new
    @field = Field.new
  end

  def create
    # render plain: params[:field].inspect
    @field = Field.new(field_params) 
    if @field.save
      flash[:success] = "Variable creada satisfactoriamente"
      redirect_to fields_path
    else
      render 'new'
    end
  end

  def show
  end

  def destroy
    @field.destroy
    flash[:success] = "Variable eliminada satisfactoriamente"
    redirect_to fields_path
  rescue ActiveRecord::InvalidForeignKey
    flash[:danger] = "Esta variable no puede ser eliminada ya que está siendo utilizada en 1 o más Protocolos"
    redirect_to fields_path
  end

  def edit
  end

  def update
    if @field.update(field_params)
      flash[:success] = "Variable actualizada satisfactoriamente"
      redirect_to fields_path
    else
      render 'edit'
    end
  end

  private
    def set_current_view
      @current_view = 'fields'
    end
    def set_role
      @field = Field.find(params[:id])
    end
    def field_params
      puts "************* #{params}"
      params.require(:field).permit(:name, :label, :field_type, :validation_type, :description, :unit_of_measure, :values)
    end

end