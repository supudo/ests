class TechnologiesController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.technologies_index'), :technologies_path
    @technology = Technology.new
    @technologies = Technology.order("title ASC").paginate(page: params[:page])
  end

  def create
    if Technology.exists?(:title => technology_params[:title])
      @notif_type = 'info'
      @notif_message = t('technology_already_exists')
    else
      ActiveRecord::Base.transaction do
        @technology = Technology.new(technology_params)
        if @technology.save
          @notif_type = 'success'
          @notif_message = t('technology_created_successfully')
        else
          @notif_type = 'danger'
          @notif_message = t('error_missing_fields')
        end
      end
    end
    respond_to do |format|
      @technologies = Technology.order("title ASC").paginate(page: params[:page])
      format.js
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @technology = Technology.find_by_id(params[:id])
      if Technology.where(:title => technology_params[:title]).where.not(:id => params[:id]).count > 0
        @notif_type = 'info'
        @notif_message = t('technology_already_exists')
      else
        if @technology.update_attributes(technology_params)
          @notif_type = 'success'
          @notif_message = t('technology_updated_successfully')
        else
          @notif_type = 'danger'
          @notif_message = t('error_missing_fields')
        end
      end
      respond_to do |format|
        @technologies = Technology.order("title ASC").paginate(page: params[:page])
        @item_id = @technology.id
        format.js
      end
    end
  end

  def destroy
    @current = Technology.find(params[:id])
    pid = @current.id
    Technology.find(params[:id]).destroy
    RatesPrice.where(:technology_id => params[:id]).destroy_all
    respond_to do |format|
      @technologies = Technology.order("title ASC").paginate(page: params[:page])
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  private

    def technology_params
      params.require(:technology).permit(:title, :style, :is_rated)
    end
end
