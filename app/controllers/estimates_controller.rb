class EstimatesController < ApplicationController
  before_action :signed_in_user
  helper_method :sort_column, :sort_direction

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.estimates_index'), estimates_path
    if params.has_key?(:iss)
      case params[:iss].to_f
        when 1
          @estimates = Estimate.where(:is_signed => 1).paginate(page: params[:page], :per_page => 10)
        when 0
          @estimates = Estimate.where(:is_signed => 0).paginate(page: params[:page], :per_page => 10)
        else
          @estimates = Estimate.paginate(page: params[:page], :per_page => 10)
      end
    else
      @estimates = Estimate.paginate(page: params[:page], :per_page => 10)
    end
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
      @rates = Rate.order("title ASC")
      @engagement_models = EngagementModel.order("title ASC")
      @positions = Position.order("title ASC")
      @chart_hours_min = ActiveRecord::Base.connection.execute("SELECT (SELECT title FROM technologies WHERE id = el.technology_id) AS technology, SUM(el.hours_min) FROM estimates_lines AS el WHERE el.estimate_id = " + params[:id] + " GROUP BY el.technology_id ORDER BY technology")
      @chart_hours_max = ActiveRecord::Base.connection.execute("SELECT (SELECT title FROM technologies WHERE id = el.technology_id) AS technology, SUM(el.hours_max) FROM estimates_lines AS el WHERE el.estimate_id = " + params[:id] + " GROUP BY el.technology_id ORDER BY technology")
      @estimate_technologies_percent_min = ActiveRecord::Base.connection.execute("SELECT t.title, SUM(hours_min) AS hours FROM technologies AS t INNER JOIN estimates_lines AS el ON el.technology_id = t.id WHERE el.estimate_id = " + params[:id] + " GROUP BY el.technology_id ORDER BY t.title")
      @estimate_technologies_percent_max = ActiveRecord::Base.connection.execute("SELECT t.title, SUM(hours_max) AS hours FROM technologies AS t INNER JOIN estimates_lines AS el ON el.technology_id = t.id WHERE el.estimate_id = " + params[:id] + " GROUP BY el.technology_id ORDER BY t.title")
      @estimate_technology_complexity = ActiveRecord::Base.connection.execute("SELECT t.title, AVG(el.complexity) AS complexity FROM estimates_lines AS el INNER JOIN technologies AS t ON t.id = el.technology_id WHERE el.estimate_id = " + params[:id] + " GROUP BY el.technology_id ORDER BY t.title")
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
    @rates = Rate.order("title ASC")
    @engagement_models = EngagementModel.order("title ASC")
  end

  def create
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.estimates_index'), estimates_path
    add_breadcrumb I18n.t('breadcrumbs.new')
    @clients = Client.order("title ASC")
    @projects = Project.order("title ASC")
    @users = User.order("first_name ASC, last_name ASC")
    @rates = Rate.order("title ASC")
    @engagement_models = EngagementModel.order("title ASC")
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
        flash[:error] = t('error_missing_fields')
        render 'new'
      end
    end
  end

  def update
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.estimates_index'), estimates_path
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @clients = Client.order("title ASC")
    @projects = Project.order("title ASC")
    @users = User.order("first_name ASC, last_name ASC")
    @estimate_line = EstimatesLine.new
    @estimatessection = EstimatesSection.where(:estimate_id => params[:id]).order("id ASC")
    @estimatesline = EstimatesLine.where(:estimate_id => params[:id]).order(sort_column + " " + sort_direction)
    @technology = Technology.order("title ASC")
    @rates = Rate.order("title ASC")
    @positions = Position.order("title ASC")
    @engagement_models = EngagementModel.order("title ASC")
    @estimates_sheets = EstimatesSheet.where(:estimate_id => params[:id]).order("id ASC")
    @chart_hours_min = ActiveRecord::Base.connection.execute("SELECT (SELECT title FROM technologies WHERE id = el.technology_id) AS technology, SUM(el.hours_min) FROM estimates_lines AS el WHERE el.estimate_id = " + params[:id] + " GROUP BY el.technology_id ORDER BY technology")
    @chart_hours_max = ActiveRecord::Base.connection.execute("SELECT (SELECT title FROM technologies WHERE id = el.technology_id) AS technology, SUM(el.hours_max) FROM estimates_lines AS el WHERE el.estimate_id = " + params[:id] + " GROUP BY el.technology_id ORDER BY technology")
    @estimate = Estimate.find_by_id(params[:id])
    @estimate.modified_user_id = current_user.id
    @estimate.modified_date = DateTime.now
    if @estimate.update_attributes(estimate_params)
      @notif_type = 'success'
      @notif_message = t('estimate_updated_successfully')
    else
      @notif_type = 'danger'
      @notif_message = t('error_missing_fields')
    end
    respond_to do |format|
      @iss = estimate_params[:is_signed]
      format.js
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      EstimatesLine.delete_all(:estimate_id => params[:id])
      EstimatesSection.delete_all(:estimate_id => params[:id])
      EstimatesSheet.delete_all(:estimate_id => params[:id])
      EstimatesAssumption.delete_all(:estimate_id => params[:id])
      Estimate.find(params[:id]).destroy
      respond_to do |format|
        @estimates = Estimate.paginate(page: params[:page], :per_page => 10)
        @notif_type = 'info'
        @notif_message = t('destimate_destroyed')
        format.js
      end
    end
  end

  private

    def estimate_params
      params.require(:estimate).permit(:title, :is_signed, :rate_id, :engagement_model_id, :client_id, :project_id, :owner_user_id)
    end

    def sort_column
      EstimatesLine.column_names.include?(params[:sort]) ? params[:sort] : "line_number"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
