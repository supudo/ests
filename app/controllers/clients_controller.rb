class ClientsController < ApplicationController
  before_action :signed_in_user

  def index
    @clients = Client.all
    render :index
  end

end
