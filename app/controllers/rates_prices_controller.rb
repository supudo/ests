class RatesPricesController < ApplicationController
  before_filter do |controller|
    controller.signed_in_user_permission("rates")
  end

  def create
    if RatesPrice.exists?(:rate_id => rates_price_params[:rate_id], :engagement_model_id => rates_price_params[:engagement_model_id], :technology_id => rates_price_params[:technology_id], :position_id => rates_price_params[:position_id])
      @notif_type = 'danger'
      @notif_message = t('rateprice_already_exists')
    else
      success = 0
      if rates_price_params[:position_id] == "" || rates_price_params[:position_id].to_f == 0
        poss = Position.where(:technology_id => rates_price_params[:technology_id])
        poss.each do |item|
          params[:rates_price][:position_id] = item.id
          rateprice = RatesPrice.new(rates_price_params)
          rateprice.modified_user_id = current_user.id
          rateprice.modified_date = DateTime.now
          if rateprice.save
            success = 1
          else
            success = 0
          end
        end
      else
        rateprice = RatesPrice.new(rates_price_params)
        rateprice.modified_user_id = current_user.id
        rateprice.modified_date = DateTime.now
        if rateprice.save
          success = 1
        else
          success = 0
        end
      end

      if success > 0
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
      @technology = Technology.where(:parent_id => 0).order("title ASC")
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
        @technology = Technology.where(:parent_id => 0).order("title ASC")
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
      @technology = Technology.where(:parent_id => 0).order("title ASC")
      @engagement_models = EngagementModel.order("title ASC")
      @currencies = Currency.order("title ASC")
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  def complex_add
    @debug_info = {}
    @rate_id = params[:rates_price][:rate_id]
    @debug_info[:rate_id] = @rate_id
    @rate = Rate.find(@rate_id)

    @engagement_model_id = 
    rps = []
    params[:hourly_rates_prices].each do |model_id, techs|
      @engagement_model_id = model_id
      techs.each do |tech_id, poss|
        poss.each do |pos_id, price_hour|

          rp = RatesPrice.new
          rp.rate_id = @rate_id
          rp.engagement_model_id = model_id
          rp.technology_id = tech_id
          rp.position_id = pos_id
          rp.hourly_rate = price_hour
          rp.daily_rate = params[:daily_rates_prices][model_id][tech_id][pos_id]
          rp.modified_user_id = @current_user.id
          rp.modified_date = DateTime.now
          rp.save
          rps.push(rp)

        end
      end
    end
    @debug_info[:rps] = rps

    respond_to do |format|
      @rates = Rate.order("title ASC")
      @technology = Technology.where(:parent_id => 0).order("title ASC")
      @engagement_models = EngagementModel.order("title ASC")
      @currencies = Currency.order("title ASC")
      @positions = Position.where("is_rated = 1").order("title ASC")
      @rates_prices = RatesPrice.where(:rate_id => params[:id]).order("technology_id ASC, position_id ASC")
      @notif_type = 'success'
      @notif_message = t('rateprice_created_successfully')
      format.js
    end
  end

  private

    def rates_price_params
      params.require(:rates_price).permit(:rate_id, :engagement_model_id, :technology_id, :position_id, :hourly_rate, :daily_rate)
    end
end
