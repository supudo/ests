class EstimatesassumptionController < ApplicationController
  before_action :signed_in_user

  def create
    if EstimatesAssumption.exists?(:estimate_id => estimates_assumption_params[:estimate_id], :title => estimates_assumption_params[:title])
      flash[:success] = t('estimate_assumption_already_exists')
      redirect_to :new_estimatesassumption
    else
      c = EstimatesAssumption.where("estimate_id = ?", estimates_assumption_params[:estimate_id]).count
      @estimate_assumption = EstimatesAssumption.new(estimates_assumption_params)
      if @estimate_assumption.save
        flash[:success] = t('estimate_assumption_created_successfully')
        redirect_to(:back)
      else
        render 'new'
      end
    end
  end

  def destroy
    @current = EstimatesAssumption.find(params[:assumption_id])
    eid = @current.estimate_id
    EstimatesAssumption.find(params[:assumption_id]).destroy
    respond_to do |format|
      @estimatesassumption = EstimatesAssumption.where(:estimate_id => eid).order("title ASC")
      format.js
    end
  end

  private

    def estimates_assumption_params
      params.require(:estimate_assumption).permit(:estimate_id, :title)
    end

end
