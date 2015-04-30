class PositionsController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.positions_index'), :positions_path
    @position = Position.new
    @positions = Position.order("title ASC").paginate(page: params[:page], :per_page => 100)
  end

  def create
    if Position.exists?(:title => position_params[:title])
      @notif_type = 'info'
      @notif_message = t('position_already_exists')
    else
      ActiveRecord::Base.transaction do
        @position = Position.new(position_params)
        if @position.save
          @notif_type = 'success'
          @notif_message = t('position_created_successfully')
        else
          @notif_type = 'danger'
          @notif_message = t('error_missing_fields')
        end
      end
    end
    respond_to do |format|
      @positions = Position.order("title ASC").paginate(page: params[:page], :per_page => 100)
      format.js
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @position = Position.find_by_id(params[:id])
      if @position.update_attributes(position_params)
        @notif_type = 'success'
        @notif_message = t('position_updated_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
      respond_to do |format|
        @positions = Position.order("title ASC").paginate(page: params[:page], :per_page => 100)
        @item_id = @position.id
        format.js
      end
    end
  end

  def destroy
    @current = Position.find(params[:id])
    pid = @current.id
    Position.find(params[:id]).destroy
    respond_to do |format|
      @positions = Position.order("title ASC").paginate(page: params[:page], :per_page => 100)
      format.js
    end
  end

  private

    def position_params
      params.require(:position).permit(:title, :is_am, :is_pdm, :is_rated)
    end
end
