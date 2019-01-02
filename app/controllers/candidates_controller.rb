class CandidatesController < ApplicationController
  before_action :set_current_view
  before_action :set_candidate, only: [:edit, :update, :show, :destroy]
  before_action :require_user

  def get_audit
    puts "** RECORD: " + params[:record_id]
    puts "** FROM: " + params[:from]
    puts "** TO: " + params[:to]

    @audit = Audit.get_audit(params[:record_id], params[:from], params[:to])
    respond_to do |format|
      format.js { render partial: 'log' }
    end
  end

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
    @candidate.current_user = current_user
    if @candidate.save
      flash[:success] = "Candidato creado satisfactoriamente"
      redirect_to candidates_path
    else
      render 'new'
    end
  end

  def destroy
    @candidate.current_user = current_user
    @candidate.destroy
    flash[:success] = "Candidato eliminado satisfactoriamente"
    redirect_to candidates_path
  end

  def edit
  end

  def update
    @candidate.current_user = current_user
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
    params.require(:candidate).permit(:curp, :name, :last_name1, :last_name2, :birth_date, :evaluation_date, :age, :phone, :cell_phone, :email, 
    :gender, :marital_status, :occupation, :occupation_other, :scolarship, :birth_city, :birth_state, :birth_country, :address_main_street, 
    :address_street_no1, :address_street_no2, :address_street1, :address_street2, :address_region, :address_city, :address_state, :address_country, 
    :diagnosis, :diagnosis_date)
  end
end
