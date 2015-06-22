class CurrenciesController < ApplicationController
  before_filter do |controller|
    controller.signed_in_user_permission("currencies")
  end

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.currencies_index'), :currencies_path
    @currencies = Currency.order("title ASC").paginate(page: params[:page])
    @currency = Currency.new
    @currencies_exchange = CurrenciesExchange.where(:from_currency_id => params[:id]).where.not(:to_currency_id => params[:id]).order("to_currency_id ASC")
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.currencies_index'), :currencies_path
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @currency = Currency.find(params[:id])
    @currencies_exchange = CurrenciesExchange.where(:from_currency_id => params[:id]).where.not(:to_currency_id => params[:id]).order("to_currency_id ASC")
    render 'edit'
  end

  def create
    if Currency.exists?(:title => currency_params[:title])
      @notif_type = 'warning'
      @notif_message = t('currency_already_exists')
    else
      ActiveRecord::Base.transaction do
        @currency = Currency.new(currency_params)
        if @currency.save
          all_currencies = Currency.where("id <> ?", @currency.id)

          all_currencies.each do |c|
            r = CurrenciesExchange.new
            r.from_currency_id = @currency.id
            r.to_currency_id = c.id
            r.rate = 1.0
            r.modified_user_id = current_user.id
            r.modified_date = DateTime.now
            r.save
          end
          @notif_type = 'success'
          @notif_message = t('currency_created_successfully')
        else
          @notif_type = 'danger'
          @notif_message = t('error_missing_fields')
        end
      end
    end
    respond_to do |format|
      @currency = Currency.new
      @currencies_exchange = CurrenciesExchange.where(:from_currency_id => params[:id]).where.not(:to_currency_id => params[:id]).order("to_currency_id ASC")
      @currencies = Currency.order("title ASC").paginate(page: params[:page])
      format.js
    end
  end

  def update_rates
    rates = params[:rates]
    rates.each do |key, value|
      if CurrenciesExchange.exists?(:from_currency_id => params[:id], :to_currency_id => key)
        r = CurrenciesExchange.find_by(:from_currency_id => params[:id], :to_currency_id => key)
        if value == nil || value.to_f <= 0
           flash[key] = key + t('currency_not_valid')
        else
          r.rate = value
          r.modified_user_id = current_user.id
          r.modified_date = DateTime.now
          r.save
        end
      else
        r = CurrenciesExchange.new
        r.from_currency_id = params[:id]
        r.to_currency_id = key
        r.rate = value
        r.modified_user_id = current_user.id
        r.modified_date = DateTime.now
        r.save
      end
    end
    redirect_to(:back)
  end

  def update
    ActiveRecord::Base.transaction do
      @currency = Currency.find_by_id(params[:id])
      if Currency.where(:title => currency_params[:title]).where.not(:id => params[:id]).count > 0
        flash[:success] = t('currency_already_exists')
        redirect_to :currencies
      else
        if @currency.update_attributes(currency_params)
          flash[:success] = t('currency_updated_successfully')
          redirect_to :currencies
        else
          add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
          add_breadcrumb I18n.t('breadcrumbs.currencies_index'), :currencies_path
          add_breadcrumb I18n.t('breadcrumbs.edit')
          flash[:error] = t('error_missing_fields')
          render 'edit'
        end
      end
    end
  end

  def destroy
    Currency.find(params[:id]).destroy
    respond_to do |format|
      @currencies = Currency.order("title ASC").paginate(page: params[:page])
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  private

    def currency_params
      params.require(:currency).permit(:title, :code, :symbol, :is_infront)
    end
end
