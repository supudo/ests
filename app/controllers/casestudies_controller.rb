class CasestudiesController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.casestudies_index'), :casestudies_path
    @filterrific = initialize_filterrific(
      Casestudy,
      params[:filterrific],
      :select_options => {
        sorted_by: Casestudy.options_for_sorted_by
      }
    ) or return
    @casestudies = @filterrific.find.page(params[:page]).order("title ASC")
    @projects = Project.order("title ASC")
    @casestudy = Casestudy.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.casestudies_index'), :casestudies_path
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @casestudy = Casestudy.find(params[:id])
    @projects = Project.order("title ASC")
    render 'edit'
  end

  def create
    if Casestudy.where(:title => casestudy_params[:title], :project_id => casestudy_params[:project_id]).count > 0
      @notif_type = 'warning'
      @notif_message = t('casestudy_already_exists')
    else
      @casestudy = Casestudy.new(casestudy_params)
      @casestudy.created_user_id = current_user.id
      @casestudy.created_date = DateTime.now
      if @casestudy.save
        @notif_type = 'success'
        @notif_message = t('casestudy_created_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @casestudies = Casestudy.order("title ASC").paginate(page: params[:page])
      @projects = Project.order("title ASC")
      @casestudy = Casestudy.new
      format.js
    end
  end

  def update
    @casestudy = Casestudy.find_by_id(params[:id])
    if Casestudy.where(:title => casestudy_params[:title], :project_id => casestudy_params[:project_id]).where.not(:id => params[:id]).count > 0
      @notif_type = 'info'
      @notif_message = t('casestudy_already_exists')
    else
      if @casestudy.update_attributes(casestudy_params)
        @notif_type = 'success'
        @notif_message = t('casestudy_updated_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @casestudies = Casestudy.order("title ASC").paginate(page: params[:page])
      @projects = Project.order("title ASC")
      @item_id = params[:id]
      @casestudy = Casestudy.new
      format.js
    end
  end

  def destroy
    Casestudy.find(params[:id]).destroy
    respond_to do |format|
      @casestudies = Casestudy.order("title ASC").paginate(page: params[:page])
      @projects = Project.order("title ASC")
      @casestudy = Casestudy.new
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  private

    def casestudy_params
      params.require(:casestudy).permit(:project_id, :title, :header_image)
    end
end
