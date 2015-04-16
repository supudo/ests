class ClientsController < ApplicationController
  before_action :signed_in_user
  autocomplete :client, :title, :full => true

  def index
    @clients = Client.order("title ASC").paginate(page: params[:page], :per_page => 10)
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.clients_index'), clients_path
  end

  def show
    if params.has_key?(:term)
      @clients = Client.where("title LIKE (?)", "%#{params[:term]}%").order("title ASC")
      respond_to do |format|
        format.json {render json: @clients.map { |client| {:id => client.id, :label => client.title, :value => client.title} }}
      end
    else
      add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
      add_breadcrumb I18n.t('breadcrumbs.clients_index'), clients_path
      add_breadcrumb I18n.t('breadcrumbs.edit')
      @client = Client.find(params[:id])
      render 'edit'
    end
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
