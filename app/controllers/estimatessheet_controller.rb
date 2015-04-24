class EstimatessheetController < ApplicationController
  before_action :signed_in_user

  def create
    if EstimatesSheet.exists?(:title => estimatessheet_params[:title], :estimate_id => estimatessheet_params[:estimate_id])
      @notif_type = 'danger'
      @notif_message = t('estimate_sheet_already_exists')
    else
      @estimatessheet = EstimatesSheet.new(estimatessheet_params)
      if @estimatessheet.save
        @notif_type = 'success'
        @notif_message = t('estimate_sheet_created_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @estimates_sheets = EstimatesSheet.where(:estimate_id => estimatessheet_params[:estimate_id]).order("id ASC")
      @estimatessection = EstimatesSection.where(:estimate_id => params[:id]).order("id ASC")
      @technology = Technology.order("title ASC")
      format.js
    end
  end

  def destroy
    redirect_to(:back)
  end

  private

    def estimatessheet_params
      params.require(:estimatessheet).permit(:title, :estimate_id)
    end

end
