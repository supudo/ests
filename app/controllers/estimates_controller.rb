class EstimatesController < ApplicationController

  def index
    @estimates = Estimate.paginate(page: params[:page], :per_page => 10)
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.estimates_index'), estimates_path
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.estimates_index'), estimates_path
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @estimate = Estimate.find(params[:id])
    @clients = Client.order("title ASC")
    @projects = Project.order("title ASC")
    @users = User.order("first_name ASC, last_name ASC")
    @estimate_line = EstimatesLine.new
    @estimatesline = EstimatesLine.where(:estimate_id => params[:id]).order("line_number ASC")
    @technology = Technology.order("title ASC")
    render 'edit'
  end

  def new
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.estimates_index'), estimates_path
    add_breadcrumb I18n.t('breadcrumbs.new')
    @estimate = Estimate.new
    @clients = Client.order("title ASC")
    @projects = Project.order("title ASC")
    @users = User.order("first_name ASC, last_name ASC")
  end

  def create
    if Estimate.exists?(:title => estimate_params[:title])
        flash[:success] = t('estimate_already_exists')
        redirect_to :new_estimate
    else
      @estimate = Estimate.new(estimate_params)
      @estimate.created_user_id = current_user.id
      @estimate.created_date = DateTime.now
      @estimate.modified_user_id = current_user.id
      @estimate.modified_date = DateTime.now
      if @estimate.save
        flash[:success] = t('estimate_created_successfully')
        redirect_to :estimates
      else
        render 'new'
      end
    end
  end

  def update
    @estimate = Estimate.find_by_id(params[:id])
    @estimate.modified_user_id = current_user.id
    @estimate.modified_date = DateTime.now
    if @estimate.update_attributes(estimate_params)
      flash[:success] = t('estimate_updated_successfully')
      redirect_to :estimates
    else
      render 'new'
    end
  end

  def destroy
    Estimate.find(params[:id]).destroy
    flash[:success] = t('estimate_destroyed')
    redirect_to :estimates
  end

  private

    def estimate_params
      params.require(:estimate).permit(:title, :client_id, :project_id, :owner_user_id)
    end

end
