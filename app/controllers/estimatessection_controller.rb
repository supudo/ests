class EstimatessectionController < ApplicationController
  before_action :signed_in_user
  helper_method :sort_column, :sort_direction

  def create
    if EstimatesSection.exists?(:estimate_id => estimates_section_params[:estimate_id], :title => estimates_section_params[:title])
      redirect_to :new_estimatessection
    else
      c = EstimatesSection.where("estimate_id = ?", estimates_section_params[:estimate_id]).count
      @estimate_section = EstimatesSection.new(estimates_section_params)
      if @estimate_section.save
        redirect_to(:back)
      else
        render 'new'
      end
    end
  end

  def destroy
    @current = EstimatesSection.find(params[:section_id])
    eid = @current.estimate_id
    EstimatesSection.find(params[:section_id]).destroy
    respond_to do |format|
      @estimatessection = EstimatesSection.where(:estimate_id => eid).order("title ASC")
      format.js
    end
  end

  private

    def estimates_section_params
      params.require(:estimate_section).permit(:estimate_id, :title)
    end

    def sort_column
      EstimatesLine.column_names.include?(params[:sort]) ? params[:sort] : "line_number"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
