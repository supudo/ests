class RatesController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.rates_index'), rates_path
    @rates = Rate.order("title ASC").paginate(page: params[:page], :per_page => 10)
  end

  def new
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.rates_index'), rates_path
    add_breadcrumb I18n.t('breadcrumbs.new')
    @rate = Rate.new
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.rates_index'), rates_path
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @rates = Rate.order("title ASC")
    @rate = @rates.where(:id => params[:id]).first
    @technology = Technology.order("title ASC")
    @engagement_models = EngagementModel.order("title ASC")
    @currencies = Currency.order("title ASC")
    @rates_prices = RatesPrice.where(:rate_id => params[:id])
    render 'edit'
  end

  def create
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.rates_index'), rates_path
    add_breadcrumb I18n.t('breadcrumbs.new')
    @rates = Rate.order("title ASC").paginate(page: params[:page], :per_page => 10)
    if Rate.exists?(:title => rate_params[:title])
      flash[:success] = t('rate_already_exists')
      redirect_to :new_rate
    else
      @rate = Rate.new(rate_params)
      @rate.modified_user_id = current_user.id
      @rate.modified_date = DateTime.now
      if @rate.save
        flash[:success] = t('rate_created_successfully')
        redirect_to :rates
      else
        flash[:error] = t('error_missing_fields')
        render 'new'
      end
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @rate = Rate.find_by_id(params[:id])
      if @rate.update_attributes(rate_params)
        flash[:success] = t('rate_updated_successfully')
        redirect_to :rates
      else
        add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
        add_breadcrumb I18n.t('breadcrumbs.rates_index'), rates_path
        add_breadcrumb I18n.t('breadcrumbs.edit')
        flash[:error] = t('error_missing_fields')
        render 'edit'
      end
    end
  end

  def destroy
    Rate.find(params[:id]).destroy
    respond_to do |format|
      @rates = Rate.order("title ASC").paginate(page: params[:page], :per_page => 10)
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  private

    def rate_params
      params.require(:rate).permit(:title)
    end

end
