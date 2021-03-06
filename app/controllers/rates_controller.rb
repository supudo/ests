class RatesController < ApplicationController
  before_filter do |controller|
    controller.signed_in_user_permission("rates")
  end

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.rates_index'), rates_path
    @rate = Rate.new
    @currencies = Currency.order("title ASC")
    @rates = Rate.order("title ASC").paginate(page: params[:page])
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.rates_index'), rates_path
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @rates = Rate.order("title ASC")
    @rate = @rates.where(:id => params[:id]).first
    @technology = Technology.where(:parent_id => 0).order("title ASC")
    @engagement_models = EngagementModel.order("title ASC")
    @currencies = Currency.order("title ASC")
    @positions = Position.where("is_rated = 1").order("title ASC")
    @rates_prices = RatesPrice.where(:rate_id => params[:id]).order("technology_id ASC, position_id ASC")
    @debug_info = {}
    render 'edit'
  end

  def create
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.rates_index'), rates_path
    add_breadcrumb I18n.t('breadcrumbs.new')
    @rates = Rate.order("title ASC").paginate(page: params[:page])
    if Rate.exists?(:title => rate_params[:title])
      @notif_type = 'warning'
      @notif_message = t('rate_already_exists')
    else
      @rate = Rate.new(rate_params)
      @rate.modified_user_id = current_user.id
      @rate.modified_date = DateTime.now
      if @rate.save
        @notif_type = 'success'
        @notif_message = t('rate_created_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @currencies = Currency.order("title ASC")
      @rates = Rate.order("title ASC").paginate(page: params[:page])
      format.js
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @rate = Rate.find_by_id(params[:id])
      if Rate.where(:title => rate_params[:title]).where.not(:id => params[:id]).count > 0
        @notif_type = 'info'
        @notif_message = t('rate_already_exists')
      else
        if @rate.update_attributes(rate_params)
          @notif_type = 'info'
          @notif_message = t('rate_updated_successfully')
        else
          @notif_type = 'danger'
          @notif_message = t('error_missing_fields')
        end
      end
      respond_to do |format|
        @currency_code = Currency.find(rate_params[:currency_id]).code
        @rates_prices = RatesPrice.where(:rate_id => @rate.id).order("technology_id ASC, position_id ASC")
        @rate_id = @rate.id
        @technology = Technology.where(:parent_id => 0).order("title ASC")
        @engagement_models = EngagementModel.order("title ASC")
        @currencies = Currency.order("title ASC")
        @positions = Position.where("is_rated = 1").order("title ASC")
        format.js
      end
    end
  end

  def destroy
    Rate.find(params[:id]).destroy
    respond_to do |format|
      @rates = Rate.order("title ASC").paginate(page: params[:page])
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  def rates_update_positions
    @positions = Position.where(:technology_id => params[:technology_id])
    @item_id = params[:item_id]
    respond_to do |format|
      format.js
    end
  end

  private

    def rate_params
      params.require(:rate).permit(:title, :currency_id)
    end

end
