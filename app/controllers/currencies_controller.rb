class CurrenciesController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.currencies_index'), :currencies_path
    @currencies = Currency.order("title ASC").paginate(page: params[:page], :per_page => 10)
  end

  def new
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.currencies_index'), :currencies_path
    add_breadcrumb I18n.t('breadcrumbs.new')
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
      flash[:success] = t('currency_already_exists')
      redirect_to :new_currency
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

          flash[:success] = t('currency_created_successfully')
          redirect_to :collections
        else
          add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
          add_breadcrumb I18n.t('breadcrumbs.currencies_index'), :currencies_path
          add_breadcrumb I18n.t('breadcrumbs.new')
          flash[:error] = t('error_missing_fields')
          render 'new'
        end
      end
    end
  end

  def update_rates
    rates = params[:rates]
    rates.each do |key, value|
      if CurrenciesExchange.exists?(:from_currency_id => params[:id], :to_currency_id => key)
        r = CurrenciesExchange.find_by(:from_currency_id => params[:id], :to_currency_id => key)
        if value == nil || value.to_f <= 0
           flash[key] = key + ' not valid!'
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
      if @currency.update_attributes(currency_params)
        flash[:success] = t('currency_updated_successfully')
        redirect_to :collections
      else
        add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
        add_breadcrumb I18n.t('breadcrumbs.collections_index'), :collections_path
        add_breadcrumb I18n.t('breadcrumbs.edit')
        flash[:error] = t('error_missing_fields')
        render 'edit'
      end
    end
  end

  def destroy
    Currency.find(params[:id]).destroy
    respond_to do |format|
      @currencies = Currency.order("title ASC").paginate(page: params[:page], :per_page => 10)
      format.js
    end
  end

  private

    def currency_params
      params.require(:currency).permit(:title, :code, :symbol)
    end
end
