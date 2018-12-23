class CandidatesController < ApplicationController
  before_action :set_current_view
  before_action :set_candidate, only: [:edit, :update, :show, :destroy]
  before_action :require_user

  def index
    @candidates = Candidate.all
  end

  def show
  end

  def new
    @candidate = Candidate.new
  end
  
  def create
    # render plain: params[:candidate].inspect
    @candidate = Candidate.new(candidate_params) 
    if @candidate.save
      flash[:success] = "Candidato creado satisfactoriamente"
      redirect_to candidates_path
    else
      render 'new'
    end
  end

  def destroy
    @candidate.destroy
    flash[:success] = "Candidato eliminado satisfactoriamente"
    redirect_to candidates_path
  end

  def edit
  end
  
  def update
    if @candidate.update(candidate_params)
      flash[:success] = "Candidato actualizado satisfactoriamente"
      redirect_to candidates_path
    else
      render 'edit'
    end
  end

  private
  def set_current_view
    @current_view = 'candidates'
  end
  def set_candidate
    @candidate = Candidate.find(params[:id])
  end
  def candidate_params
    params.require(:candidate).permit(:curp, :name, :last_name1, :last_name2, :birth_date)
  end
end
