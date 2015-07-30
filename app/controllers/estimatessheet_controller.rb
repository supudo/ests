class EstimatessheetController < ApplicationController
  before_filter do |controller|
    controller.signed_in_user_permission("estimates")
  end

  helper_method :sort_column, :sort_direction

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
      @estimate = Estimate.find(estimatessheet_params[:estimate_id])
      @clients = Client.order("title ASC")
      @projects = Project.order("title ASC")
      @users = User.order("first_name ASC, last_name ASC")
      @estimates_sheets = EstimatesSheet.where(:estimate_id => estimatessheet_params[:estimate_id]).order("id ASC")
      @estimate_line = EstimatesLine.new
      @estimatesassumption = EstimatesAssumption.where(:estimate_id => estimatessheet_params[:estimate_id]).order("title ASC")
      @estimatessection = EstimatesSection.where(:estimate_id => estimatessheet_params[:estimate_id]).order("id ASC")
      @technology = Technology.order("title ASC")
      @positions = Position.order("title ASC")
      params[:id] = estimatessheet_params[:estimate_id]
      format.js
    end
  end

  def destroy
    EstimatesSheet.find(params[:id]).destroy
    respond_to do |format|
      @estimates_sheets = EstimatesSheet.where(:estimate_id => estimatessheet_params[:estimate_id]).order("id ASC")
      @estimatessection = EstimatesSection.where(:estimate_id => estimatessheet_params[:estimate_id]).order("id ASC")
      @technology = Technology.order("title ASC")
      @positions = Position.order("title ASC")
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  private

    def estimatessheet_params
      params.require(:estimatessheet).permit(:title, :estimate_id)
    end

    def sort_column
      EstimatesLine.column_names.include?(params[:sort]) ? params[:sort] : "line_number"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
