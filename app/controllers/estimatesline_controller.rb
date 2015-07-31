class EstimateslineController < ApplicationController
  before_filter do |controller|
    controller.signed_in_user_permission("estimates")
  end

  autocomplete :estimatesline, :line, :full => true
  helper_method :sort_column, :sort_direction

  def show
    @estimatesline = EstimatesLine.select(:position_id, :technology_id, :line, :hours_min, :hours_max).where("line LIKE (?)", "%#{params[:term]}%").order("line ASC").distinct
    respond_to do |format|
      format.json {render json: @estimatesline.map { |line| {:label => line.line + ' (' + line.position.title + ' @ ' + line.technology.title + '; ' + line.hours_min.to_s + '~' + line.hours_max.to_s + ')',
                                                             :value => line.line,
                                                             :technology => line.technology_id,
                                                             :hours_min => line.hours_min,
                                                             :hours_max => line.hours_max
                                                            }
                                                    }
                  }
    end
  end

  def create
    if EstimatesLine.exists?(:estimate_id => estimates_line_params[:estimate_id], :estimates_sections_id => estimates_line_params[:estimates_sections_id], :line => estimates_line_params[:line], :technology_id => estimates_line_params[:technology_id])
      @notif_type = 'warning'
      @notif_message = t('estimate_line_already_exists')
    else
      c = EstimatesLine.where("estimate_id = ?", estimates_line_params[:estimate_id]).count
      @estimate_line = EstimatesLine.new(estimates_line_params)
      @estimate_line.created_user_id = current_user.id
      @estimate_line.created_date = DateTime.now
      @estimate_line.line_number = c + 1
      if @estimate_line.save
        @notif_type = 'info'
        @notif_message = t('estimate_line_created_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @positions = Position.order("title ASC")
      @estimatessection = EstimatesSection.where(:estimate_id => estimates_line_params[:estimate_id]).order("section_number ASC")
      @sheet = EstimatesSheet.find(EstimatesSection.find_by_id(estimates_line_params[:estimates_sections_id]).estimates_sheet_id)
      params[:id] = estimates_line_params[:estimate_id]
      @estimate = Estimate.find_by_id(estimates_line_params[:estimate_id])
      @esection_id = estimates_line_params[:estimates_sections_id]
      @sheet_id = @sheet.id
      format.js
    end
  end

  def update
    eline = EstimatesLine.find_by(:id => params[:estimates_line][:estimate_line_id])
    eline.line = params[:estimates_line][:line]
    eline.technology_id = params[:estimates_line][:technology_id]
    eline.position_id = params[:estimates_line][:position_id]
    eline.hours_min = params[:estimates_line][:hours_min]
    eline.hours_max = params[:estimates_line][:hours_max]
    if eline.save
      @notif_type = 'info'
      @notif_message = t('estimate_line_updated_successfully')
    else
      @notif_type = 'danger'
      @notif_message = t('error_missing_fields')
    end
    @positions = Position.order("title ASC")
    @eitem_id = params[:estimates_line][:estimate_line_id]
    @eitem_section_id = eline.estimates_sections_id
    @eitem_sheet_id = EstimatesSection.find_by_id(eline.estimates_sections_id).estimates_sheet_id
    respond_to do |format|
      @estimatessection = EstimatesSection.where(:estimate_id => params[:id]).order("section_number ASC")
      @sheet = EstimatesSheet.find(@eitem_sheet_id)
      @estimate = Estimate.find_by_id(params[:estimates_line][:estimate_id])
      @positions = Position.order("title ASC")
      format.js
    end
  end

  def destroy
    @current = EstimatesLine.find(params[:line_id])
    eid = @current.estimate_id
    @esection_id = @current.estimates_sections_id
    @esheet_id = EstimatesSection.find_by_id(@esection_id).estimates_sheet_id
    EstimatesLine.find(params[:line_id]).destroy
    respond_to do |format|
      @estimatessection = EstimatesSection.where(:estimate_id => eid).order("section_number ASC")
      @sheet = EstimatesSheet.find(@estimatessection.first.estimates_sheet_id)
      @estimate = Estimate.find_by_id(eid)
      @positions = Position.order("title ASC")
      @estimatesline = EstimatesLine.where(:estimate_id => @estimatessection.first.estimate_id, :estimates_sections_id => @estimatessection.first.id).order("line_number ASC")
      @notif_type = 'success'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  def moveup
    @current = EstimatesLine.find(params[:id])
    @above = EstimatesLine.order("line_number DESC").where("line_number < ? AND estimates_sections_id = ?", @current.line_number, @current.estimates_sections_id).first
    ln = @above.line_number
    @above.line_number = @current.line_number
    @above.save
    @current.line_number = ln
    @current.save
    respond_to do |format|
      @estimatessection = EstimatesSection.where(:estimate_id => params[:id]).order("section_number ASC")
      @estimatesline = EstimatesLine.where(:estimate_id => @current.estimate_id, :estimates_sections_id => @current.estimates_sections_id).order("line_number ASC")
      @current_section = EstimatesSection.find(@current.estimates_sections_id)
      @positions = Position.order("title ASC")
      @estimate = Estimate.find_by_id(@current.estimate_id)
      format.js
    end
  end

  def movedown
    @current = EstimatesLine.find(params[:id])
    @bellow = EstimatesLine.order("line_number ASC").where("line_number > ? AND estimates_sections_id = ?", @current.line_number, @current.estimates_sections_id).first
    ln = @bellow.line_number
    @bellow.line_number = @current.line_number
    @bellow.save
    @current.line_number = ln
    @current.save
    respond_to do |format|
      @estimatessection = EstimatesSection.where(:estimate_id => params[:id]).order("section_number ASC")
      @estimatesline = EstimatesLine.where(:estimate_id => @current.estimate_id, :estimates_sections_id => @current.estimates_sections_id).order("line_number ASC")
      @current_section = EstimatesSection.find(@current.estimates_sections_id)
      @positions = Position.order("title ASC")
      @estimate = Estimate.find_by_id(@current.estimate_id)
      format.js
    end
  end

  def lines_update_positions
    @positions = Position.where(:technology_id => params[:technology_id])
    @item_id = params[:item_id]
    respond_to do |format|
      format.js
    end
  end

  private

    def estimates_line_params
      params.require(:estimate_line).permit(:estimate_id, :estimates_sections_id, :technology_id, :position_id, :line_number, :line, :hours_min, :hours_max)
    end

    def sort_column
      EstimatesLine.column_names.include?(params[:sort]) ? params[:sort] : "line_number"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
