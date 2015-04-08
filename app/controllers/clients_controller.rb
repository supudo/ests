class ClientsController < ApplicationController
  before_action :signed_in_user

  def index
    @clients = Client.order("title ASC").paginate(page: params[:page], :per_page => 10)
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.clients_index'), clients_path
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.clients_index'), clients_path
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @client = Client.find(params[:id])
    render 'edit'
  end

  def new
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.clients_index'), clients_path
    add_breadcrumb I18n.t('breadcrumbs.new')
    @client = Client.new
  end

  def create
    if Client.exists?(:title => client_params[:title])
        flash[:success] = t('client_already_exists')
        redirect_to :new_client
    else
      @client = Client.new(client_params)
      if @client.save
        flash[:success] = t('client_created_successfully')
        redirect_to :clients
      else
        render 'new'
      end
    end
  end

  def update
    @client = Client.find_by_id(params[:id])
    if @client.update_attributes(client_params)
      flash[:success] = t('client_updated_successfully')
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
