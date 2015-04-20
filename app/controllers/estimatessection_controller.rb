class EstimatessectionController < ApplicationController
  before_action :signed_in_user
  helper_method :sort_column, :sort_direction

  def create
    if EstimatesSection.exists?(:estimates_sheet_id => estimates_section_params[:estimates_sheet_id], :title => estimates_section_params[:title])
      redirect_to :new_estimatessection
    else
      @estimate_section = EstimatesSection.new(estimates_section_params)
      if @estimate_section.save
        redirect_to(:back)
      else
        render 'new'
      end
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

    def sort_column
      EstimatesLine.column_names.include?(params[:sort]) ? params[:sort] : "line_number"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
