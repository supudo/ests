class EstimatessheetController < ApplicationController
  before_action :signed_in_user

  def create
    if EstimatesSheet.exists?(:title => estimatessheet_params[:title], :estimate_id => estimatessheet_params[:estimate_id])
      flash[:success] = t('estimate_sheet_already_exists')
      redirect_to(:back)
    else
      @estimatessheet = EstimatesSheet.new(estimatessheet_params)
      if @estimatessheet.save
        flash[:success] = t('estimate_sheet_created_successfully')
        redirect_to(:back)
      else
        flash[:error] = t('error_missing_fields')
        render 'new'
      end
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
