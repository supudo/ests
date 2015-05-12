class EstimatessectionController < ApplicationController
  before_action :signed_in_user
  helper_method :sort_column, :sort_direction

  def show
    pos_id = Position.where(:technology_id => esection_technology_params[:tid]).order("complexity ASC").first.id
    EstimatesLine.where(:estimates_sections_id => params[:id]).update_all(:technology_id => esection_technology_params[:tid], :position_id => pos_id)
    @current = EstimatesSection.find(params[:id])
    @estimatesline = EstimatesLine.where(:estimates_sections_id => @current.id).order("line_number ASC")
    @positions = Position.order("title ASC")
    respond_to do |format|
      @notif_type = 'success'
      @notif_message = t('section_technology_changed')
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
    respond_to do |format|
      @estimatessection = EstimatesSection.where(:estimate_id => estimates_section_params[:estimate_id]).order("id ASC")
      @positions = Position.order("title ASC")
      @sheet = EstimatesSheet.find(estimates_section_params[:estimates_sheet_id])
      format.js
    end
  end

  def update
    esection = EstimatesSection.find(estimates_section_params[:section_id])
    esection.title = estimates_section_params[:title]
    esection.save
    respond_to do |format|
      @eitem_id = esection.id
      @new_title = estimates_section_params[:title]
      @notif_type = 'success'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  def destroy
    EstimatesSection.find(params[:section_id]).destroy
    @estimatessection = EstimatesSection.where(:estimate_id => params[:estimate_id]).order("id ASC")
    @sheet = EstimatesSheet.find(params[:estimates_sheet_id])
    respond_to do |format|
      @notif_type = 'success'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  private

    def estimates_section_params
      params.require(:estimate_section).permit(:estimate_id, :section_id, :estimates_sheet_id, :title)
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
