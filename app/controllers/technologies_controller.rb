class TechnologiesController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.technologies_index'), technologies_path
    @technologies = Technology.order("title ASC").paginate(page: params[:page], :per_page => 10)
  end

  def new
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.technologies_index'), technologies_path
    add_breadcrumb I18n.t('breadcrumbs.new')
    @technology = Technology.new
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.technologies_index'), technologies_path
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @technology = Technology.find(params[:id])
    render 'edit'
  end

  def create
    if Technology.exists?(:title => technology_params[:title])
      flash[:success] = t('technology_already_exists')
      redirect_to :new_project
    else
      ActiveRecord::Base.transaction do
        @technology = Technology.new(technology_params)
        if @technology.save
          flash[:success] = t('technology_created_successfully')
          redirect_to :technologies
        else
          add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
          add_breadcrumb I18n.t('breadcrumbs.technologies_index'), technologies_path
          add_breadcrumb I18n.t('breadcrumbs.new')
          @technology = Technology.new
          flash[:error] = t('error_missing_fields')
          render 'new'
        end
      end
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @technology = Technology.find_by_id(params[:id])
      if @technology.update_attributes(technology_params)
        flash[:success] = t('technology_updated_successfully')
        redirect_to :technologies
      else
        add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
        add_breadcrumb I18n.t('breadcrumbs.technologies_index'), technologies_path
        add_breadcrumb I18n.t('breadcrumbs.edit')
        @technology = Technology.new
        flash[:error] = t('error_missing_fields')
        render 'edit'
      end
    end
  end

  def destroy
    @current = Technology.find(params[:id])
    pid = @current.id
    Technology.find(params[:id]).destroy
    respond_to do |format|
      @technologies = Technology.order("title ASC").paginate(page: params[:page], :per_page => 10)
      format.js
    end
  end

  private

    def technology_params
      params.require(:technology).permit(:title)
    end
end
