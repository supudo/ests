class EstimatessectionController < ApplicationController
  before_filter do |controller|
    controller.signed_in_user_permission("estimates")
  end

  helper_method :sort_column, :sort_direction

  def show
    pos_id = Position.where(:technology_id => esection_technology_params[:tid]).order("complexity ASC").first.id
    EstimatesLine.where(:estimates_sections_id => params[:id]).update_all(:technology_id => esection_technology_params[:tid], :position_id => pos_id)
    @current = EstimatesSection.find(params[:id])
    @estimatesline = EstimatesLine.where(:estimates_sections_id => @current.id).order("line_number ASC")
    @positions = Position.order("title ASC")
    @estimate = Estimate.find_by_id(@current.estimate_id)
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
      c = EstimatesSection.where("estimates_sheet_id = ?", estimates_section_params[:estimates_sheet_id]).order("section_number DESC").first
      if !c.nil?
        @es.section_number = c.section_number + 1
      else
        @es.section_number = 1
      end
      if @es.save
        @notif_type = 'success'
        @notif_message = t('sections_created_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @estimatessection = EstimatesSection.where(:estimate_id => estimates_section_params[:estimate_id]).order("section_number ASC")
      @positions = Position.order("title ASC")
      @sheet = EstimatesSheet.find(estimates_section_params[:estimates_sheet_id])
      @estimate = Estimate.find_by_id(@sheet.estimate_id)
      params[:id] = estimates_section_params[:estimate_id]
      @sheet_id = @sheet.id
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
      @estimate = Estimate.find_by_id(esection.estimate_id)
      @notif_type = 'success'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  def destroy
    EstimatesSection.find(params[:section_id]).destroy
    EstimatesLine.where(:estimates_sections_id => params[:section_id]).destroy_all
    @estimatessection = EstimatesSection.where(:estimate_id => params[:estimate_id]).order("section_number ASC")
    @sheet = EstimatesSheet.find(params[:estimates_sheet_id])
    @positions = Position.order("title ASC")
    @estimate = Estimate.find_by_id(params[:estimate_id])
    @sheet_id = @sheet.id
    respond_to do |format|
      @notif_type = 'success'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  def moveup
    @current = EstimatesSection.find(params[:id])
    @above = EstimatesSection.order("section_number DESC").where("section_number < ? AND estimates_sheet_id = ?", @current.section_number, @current.estimates_sheet_id).first
    sn = @above.section_number
    @above.section_number = @current.section_number
    @above.save
    @current.section_number = sn
    @current.save
    respond_to do |format|
      @estimatessection = EstimatesSection.where(:estimate_id => @current.estimate_id).order("section_number ASC")
      @sheet = EstimatesSheet.find(@current.estimates_sheet_id)
      @positions = Position.order("title ASC")
      @estimate = Estimate.find_by_id(@current.estimate_id)
      @sheet_id = @current.estimates_sheet_id
      format.js
    end
  end

  def movedown
    @current = EstimatesSection.find(params[:id])
    @bellow = EstimatesSection.order("section_number ASC").where("section_number > ? AND estimates_sheet_id = ?", @current.section_number, @current.estimates_sheet_id).first
    sn = @bellow.section_number
    @bellow.section_number = @current.section_number
    @bellow.save
    @current.section_number = sn
    @current.save
    respond_to do |format|
      @estimatessection = EstimatesSection.where(:estimate_id => @current.estimate_id).order("section_number ASC")
      @sheet = EstimatesSheet.find(@current.estimates_sheet_id)
      @positions = Position.order("title ASC")
      @estimate = Estimate.find_by_id(@current.estimate_id)
      @sheet_id = @current.estimates_sheet_id
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
