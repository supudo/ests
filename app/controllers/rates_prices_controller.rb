class RatesPricesController < ApplicationController
  before_action :signed_in_user

  def create
    if RatesPrice.exists?(:engagement_model_id => rates_price_params[:engagement_model_id], :technology_id => rates_price_params[:technology_id], :position_id => rates_price_params[:position_id])
      @notif_type = 'danger'
      @notif_message = t('rateprice_already_exists')
    else
      @rateprice = RatesPrice.new(rates_price_params)
      @rateprice.modified_user_id = current_user.id
      @rateprice.modified_date = DateTime.now
      if @rateprice.save
        @notif_type = 'success'
        @notif_message = t('rateprice_created_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @rates_prices = RatesPrice.where(:rate_id => rates_price_params[:rate_id]).order("technology_id ASC, position_id ASC")
      @positions = Position.where("is_rated = 1").order("title ASC")
      @rate_id = rates_price_params[:rate_id]
      @rate = Rate.find(@rate_id)
      @technology = Technology.order("title ASC")
      @engagement_models = EngagementModel.order("title ASC")
      @currencies = Currency.order("title ASC")
      format.js
    end
  end

  def update
    ActiveRecord::Base.transaction do
      rate_price = RatesPrice.find(params[:rates_price][:rate_price_id])
      if rate_price.update_attributes(rates_price_params)
        @notif_type = 'success'
        @notif_message = t('rateprice_created_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
      respond_to do |format|
        @rates_prices = RatesPrice.where(:rate_id => rates_price_params[:rate_id]).order("technology_id ASC, position_id ASC")
        @positions = Position.where("is_rated = 1").order("title ASC")
        @rate_id = rates_price_params[:rate_id]
        @rate = Rate.find(@rate_id)
        @rate_price_id = params[:rates_price][:rate_price_id]
        @technology = Technology.order("title ASC")
        @engagement_models = EngagementModel.order("title ASC")
        @currencies = Currency.order("title ASC")
        @engagement_model_id = rate_price.engagement_model_id
        format.js
      end
    end
  end

  def destroy
    @engagement_model_id = RatesPrice.find(params[:id]).engagement_model_id
    RatesPrice.find(params[:rp][:rate_price_id]).destroy
    respond_to do |format|
      @rates_prices = RatesPrice.where(:rate_id => params[:rp][:rate_id]).order("technology_id ASC, position_id ASC")
      @positions = Position.where("is_rated = 1").order("title ASC")
      @rate_id = params[:rp][:rate_id]
      @rate = Rate.find(@rate_id)
      @technology = Technology.order("title ASC")
      @engagement_models = EngagementModel.order("title ASC")
      @currencies = Currency.order("title ASC")
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  private

    def rates_price_params
      params.require(:rates_price).permit(:rate_id, :engagement_model_id, :technology_id, :position_id, :hourly_rate, :daily_rate)
    end
end
