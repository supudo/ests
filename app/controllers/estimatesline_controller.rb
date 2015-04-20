class EstimateslineController < ApplicationController
  before_action :signed_in_user
  autocomplete :estimatesline, :line, :full => true

  def show
    @estimatesline = EstimatesLine.where("line LIKE (?)", "%#{params[:term]}%").order("line ASC")
    respond_to do |format|
      format.json {render json: @estimatesline.map { |line| {:id => line.id, :label => line.line, :value => line.line} }}
    end
  end

  def create
    if EstimatesLine.exists?(:estimate_id => estimates_line_params[:estimate_id], :line => estimates_line_params[:line], :technology_id => estimates_line_params[:technology_id])
      flash[:success] = t('estimate_line_already_exists')
      render 'new'
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
    @current = EstimatesLine.find(params[:line_id])
    eid = @current.estimate_id
    EstimatesLine.find(params[:line_id]).destroy
    respond_to do |format|
      @estimatesline = EstimatesLine.where(:estimate_id => eid).order("line_number ASC")
      format.js
    end
  end

  def moveup
    @current = EstimatesLine.find(params[:id])
    @above = EstimatesLine.find_by(:line_number => (@current.line_number - 1), :estimate_id => @current.estimate_id)
    ln = @above.line_number
    @above.line_number = @current.line_number
    @above.save
    @current.line_number = ln
    @current.save
    respond_to do |format|
      @estimatesline = EstimatesLine.where(:estimate_id => @current.estimate_id).order("line_number ASC")
      format.js
    end
  end

  def movedown
    @current = EstimatesLine.find(params[:id])
    @bellow = EstimatesLine.find_by(:line_number => (@current.line_number + 1), :estimate_id => @current.estimate_id)
    ln = @bellow.line_number
    @bellow.line_number = @current.line_number
    @bellow.save
    @current.line_number = ln
    @current.save
    respond_to do |format|
      @estimatesline = EstimatesLine.where(:estimate_id => @current.estimate_id).order("line_number ASC")
      format.js
    end
  end

  private

    def estimates_line_params
      params.require(:estimate_line).permit(:estimate_id, :estimates_sections_id, :technology_id, :line_number, :line, :complexity, :hours_min, :hours_max)
    end

end
