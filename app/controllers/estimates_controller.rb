class EstimatesController < ApplicationController
  before_action :signed_in_user
  helper_method :sort_column, :sort_direction

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.estimates_index'), estimates_path
    @estimates = Estimate.paginate(page: params[:page], :per_page => 10)
  end

  def show
    if params.has_key?(:term)
      @estimates = Estimate.where("title LIKE (?)", "%#{params[:term]}%").order("title ASC")
      respond_to do |format|
        format.json {render json: @estimates.map { |estimate| {:id => estimate.id, :label => estimate.title, :value => estimate.title} }}
      end
    else
      add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
      add_breadcrumb I18n.t('breadcrumbs.estimates_index'), estimates_path
      add_breadcrumb I18n.t('breadcrumbs.edit')
      @estimate = Estimate.find(params[:id])
      @clients = Client.order("title ASC")
      @projects = Project.order("title ASC")
      @users = User.order("first_name ASC, last_name ASC")
      @estimates_sheets = EstimatesSheet.where(:estimate_id => params[:id]).order("id ASC")
      @estimate_line = EstimatesLine.new
      @estimatesassumption = EstimatesAssumption.where(:estimate_id => params[:id]).order("title ASC")
      @estimatessection = EstimatesSection.where(:estimate_id => params[:id]).order("id ASC")
      @technology = Technology.order("title ASC")
      render 'edit'
    end
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
        @estimates_sheet = EstimatesSheet.new(:title => estimate_params[:title], :estimate_id => @estimate.id)
        flash[:success] = t('estimate_created_successfully')
        redirect_to :estimates
      else
        add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
        add_breadcrumb I18n.t('breadcrumbs.estimates_index'), estimates_path
        add_breadcrumb I18n.t('breadcrumbs.new')
        @estimate = Estimate.new
        @clients = Client.order("title ASC")
        @projects = Project.order("title ASC")
        @users = User.order("first_name ASC, last_name ASC")
        flash[:error] = t('error_missing_fields')
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
      add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
      add_breadcrumb I18n.t('breadcrumbs.estimates_index'), estimates_path
      add_breadcrumb I18n.t('breadcrumbs.edit')
      @estimate = Estimate.find(params[:id])
      @clients = Client.order("title ASC")
      @projects = Project.order("title ASC")
      @users = User.order("first_name ASC, last_name ASC")
      @estimate_line = EstimatesLine.new
      @estimatessection = EstimatesSection.where(:estimate_id => params[:id]).order("id ASC")
      @estimatesline = EstimatesLine.where(:estimate_id => params[:id]).order(sort_column + " " + sort_direction)
      @technology = Technology.order("title ASC")
      flash[:error] = t('error_missing_fields')
      render 'new'
    end
  end

  def destroy
    Estimate.find(params[:id]).destroy
    respond_to do |format|
      @estimates = Estimate.paginate(page: params[:page], :per_page => 10)
      flash[:success] = t('estimate_destroyed')
      format.js
    end
  end

  private

    def estimate_params
      params.require(:estimate).permit(:title, :client_id, :project_id, :owner_user_id)
    end

    def sort_column
      EstimatesLine.column_names.include?(params[:sort]) ? params[:sort] : "line_number"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
