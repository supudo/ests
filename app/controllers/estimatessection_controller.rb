class EstimatessectionController < ApplicationController
  before_action :signed_in_user
  helper_method :sort_column, :sort_direction

  def show
    EstimatesLine.where(:estimates_sections_id => params[:id]).update_all(:technology_id => esection_technology_params[:tid])
    respond_to do |format|
      format.js
    end
  end

  def create
    @es = EstimatesSection.where(:estimates_sheet_id => estimates_section_params[:estimates_sheet_id], :title => estimates_section_params[:title]).first
    if @es != nil
      @notif_type = 'warning'
      @notif_message = t('section_already_exists')
    else
      @es = EstimatesSection.new(estimates_section_params)
      if @es.save
        @notif_type = 'success'
        @notif_message = t('sections_created_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    @estimatessection = EstimatesSection.where(:estimate_id => @es.estimate_id).order("id ASC")
    @sheet = EstimatesSheet.find(estimates_section_params[:estimates_sheet_id])
    respond_to do |format|
      format.js
    end
  end

  def update
    esection = EstimatesSection.find_by(:id => estimates_section_params[:section_id])
    esection.title = estimates_section_params[:title]
    esection.save
    respond_to do |format|
      @eitem_id = esection.id
      @new_title = estimates_section_params[:title]
      format.js
    end
  end

  def destroy
    @current = EstimatesSection.find(params[:id])
    eid = @current.estimate_id
    EstimatesSection.find(params[:id]).destroy
    redirect_to(:back)
  end

  private

    def estimates_section_params
      params.require(:estimate_section).permit(:estimate_id, :estimates_sheet_id, :title)
    end

    def esection_technology_params
      params.require(:esection_technology).permit(:sid, :tid)
    end

    def sort_column
      EstimatesLine.column_names.include?(params[:sort]) ? params[:sort] : "line_number"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
