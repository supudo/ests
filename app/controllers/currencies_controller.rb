class CurrenciesController < ApplicationController
  before_action :signed_in_user

  def new
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.collections_index'), :collections_path
    add_breadcrumb I18n.t('breadcrumbs.new')
    @currency = Currency.new
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.collections_index'), :collections_path
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @currency = Currency.find(params[:id])
    render 'edit'
  end

  def create
    if Currency.exists?(:title => currency_params[:title])
      flash[:success] = t('position_already_exists')
      redirect_to :new_currency
    else
      ActiveRecord::Base.transaction do
        @currency = Currency.new(currency_params)
        if @currency.save
          flash[:success] = t('position_created_successfully')
          redirect_to :collections
        else
          add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
          add_breadcrumb I18n.t('breadcrumbs.collections_index'), :collections_path
          add_breadcrumb I18n.t('breadcrumbs.new')
          flash[:error] = t('error_missing_fields')
          render 'new'
        end
      end
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @currency = Currency.find_by_id(params[:id])
      if @currency.update_attributes(currency_params)
        flash[:success] = t('position_updated_successfully')
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
