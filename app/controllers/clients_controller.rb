class ClientsController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.clients_index'), clients_path
    @filterrific = initialize_filterrific(
      Client,
      params[:filterrific],
      :select_options => {
        sorted_by: Client.options_for_sorted_by
      }
    ) or return
    @clients = @filterrific.find.page(params[:page]).order("title ASC")
    @client = Client.new
    respond_to do |format|
      format.html
      format.js
    end
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

  def create
    if Client.exists?(:title => client_params[:title])
      @notif_type = 'warning'
      @notif_message = t('client_already_exists')
    else
      @client = Client.new(client_params)
      if @client.save
        @notif_type = 'success'
        @notif_message = t('client_created_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @client = Client.new
      @clients = Client.order("title ASC").paginate(page: params[:page], :per_page => 30)
      format.js
    end
  end

  def update
    @client = Client.find_by_id(params[:id])
    if @client.update_attributes(client_params)
      @notif_type = 'success'
      @notif_message = t('client_updated_successfully')
    else
      @notif_type = 'danger'
      @notif_message = t('error_missing_fields')
    end
    respond_to do |format|
      @clients = Client.order("title ASC").paginate(page: params[:page], :per_page => 30)
      @item_id = @client.id
      format.js
    end
  end

  def destroy
    Client.find(params[:id]).destroy
    flash[:success] = t('client_destroyed')
    respond_to do |format|
      @clients = Client.order("title ASC").paginate(page: params[:page], :per_page => 10)
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  private

    def client_params
      params.require(:client).permit(:title, :email, :url, :phone)
    end

end
