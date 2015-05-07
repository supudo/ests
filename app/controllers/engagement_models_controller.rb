class EngagementModelsController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.engagement_models_index'), :engagement_models_path
    @engagement_model = EngagementModel.new
    @engagement_models = EngagementModel.paginate(page: params[:page])
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.engagement_models_index'), :engagement_models_path
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @engagement_model = EngagementModel.find(params[:id])
    render 'edit'
  end

  def create
    if EngagementModel.exists?(:title => engagement_model_params[:title])
      @notif_type = 'warning'
      @notif_message = t('engagement_model_already_exists')
    else
      ActiveRecord::Base.transaction do
        @engagement_model = EngagementModel.new(engagement_model_params)
        if @engagement_model.save
          @notif_type = 'success'
          @notif_message = t('engagement_model_created_successfully')
        else
          @notif_type = 'danger'
          @notif_message = t('error_missing_fields')
        end
      end
    end
    respond_to do |format|
      @engagement_models = EngagementModel.paginate(page: params[:page])
      format.js
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @engagement_model = EngagementModel.find_by_id(params[:id])
      if @engagement_model.update_attributes(engagement_model_params)
        @notif_type = 'success'
        @notif_message = t('engagement_model_updated_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
      respond_to do |format|
        @engagement_models = EngagementModel.paginate(page: params[:page])
        @item_id = @engagement_model.id
        format.js
      end
    end
  end

  def destroy
    EngagementModel.find(params[:id]).destroy
    respond_to do |format|
      @engagement_models = EngagementModel.paginate(page: params[:page])
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  private

    def engagement_model_params
      params.require(:engagement_model).permit(:title)
    end
end
