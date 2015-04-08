class EstimateslineController < ApplicationController

  def create
    if EstimatesLine.exists?(:estimate_id => estimates_line_params[:estimate_id], :line => estimates_line_params[:line], :technology_id => estimates_line_params[:technology_id])
        flash[:success] = t('estimate_line_already_exists')
        redirect_to :new_estimate
    else
      c = EstimatesLine.where("estimate_id = ?", estimates_line_params[:estimate_id]).count
      @estimate_line = EstimatesLine.new(estimates_line_params)
      @estimate_line.created_user_id = current_user.id
      @estimate_line.created_date = DateTime.now
      @estimate_line.line_number = c + 1
      if @estimate_line.save
        flash[:success] = t('estimate_line_created_successfully')
        redirect_to(:back)
      else
        render 'new'
      end
    end
  end

  def destroy
    EstimatesLine.find(params[:line_id]).destroy
    flash[:success] = t('estimate_line_destroyed')
    redirect_to(:back)
  end

  private

    def estimates_line_params
      params.require(:estimate_line).permit(:estimate_id, :technology_id, :line_number, :line, :complexity, :hours_min, :hours_max)
    end

end
