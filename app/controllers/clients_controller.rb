class ClientsController < ApplicationController
  before_action :signed_in_user

  def index
    @clients = Client.paginate(page: params[:page], :per_page => 10)
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.clients_index'), clients_path
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.clients_index'), clients_path
    add_breadcrumb I18n.t('breadcrumbs.clients_edit')
    @client = Client.find(params[:id])
    render 'edit'
  end

  def new
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.clients_index'), clients_path
    add_breadcrumb I18n.t('breadcrumbs.clients_new')
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      flash[:success] = t('client_updated_successfully')
      redirect_to :clients
    else
      render 'new'
    end
  end

  def update
    @client = Client.find_by_id(params[:id])
    if @client.update_attributes(client_params)
      flash[:success] = t('profile_updated')
      redirect_to :clients
    else
      render 'edit'
    end
  end

  def destroy
    Client.find(params[:id]).destroy
    flash[:success] = t('client_destroyed')
    redirect_to :clients
  end

  private

    def client_params
      params.require(:client).permit(:title, :email, :url, :phone)
    end

end
