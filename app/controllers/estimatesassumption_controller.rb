class EstimatesassumptionController < ApplicationController
  before_filter do |controller|
    controller.signed_in_user_permission("estimates")
  end

  def create
    @estimatesassumption = EstimatesAssumption.where(:estimate_id => estimates_assumption_params[:estimate_id]).order("title ASC")
    if EstimatesAssumption.exists?(:estimate_id => estimates_assumption_params[:estimate_id], :title => estimates_assumption_params[:title])
      @notif_type = 'warning'
      @notif_message = t('estimate_assumption_already_exists')
    else
      @estimate_assumption = EstimatesAssumption.new(estimates_assumption_params)
      if @estimate_assumption.save
        @notif_type = 'success'
        @notif_message = t('estimate_assumption_created_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @current = EstimatesAssumption.find(params[:assumption_id])
    eid = @current.estimate_id
    EstimatesAssumption.find(params[:assumption_id]).destroy
    respond_to do |format|
      @estimatesassumption = EstimatesAssumption.where(:estimate_id => eid).order("title ASC")
      @notif_type = 'success'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  private

    def estimates_assumption_params
      params.require(:estimate_assumption).permit(:estimate_id, :title)
    end

end
