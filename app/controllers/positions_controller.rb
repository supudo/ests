class PositionsController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.positions_index'), :positions_path
    @filterrific = initialize_filterrific(
      Position,
      params[:filterrific],
      :select_options => {
        sorted_by: Position.options_for_sorted_by
      }
    ) or return
    @positions = @filterrific.find.page(params[:page])
    @positions = @positions.order("technology_id ASC, complexity ASC, title ASC")

    @position = Position.new
    @technologies = Technology.order("title ASC")

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    if Position.exists?(:title => position_params[:title], :technology_id => position_params[:technology_id])
      @notif_type = 'info'
      @notif_message = t('position_already_exists')
    else
      ActiveRecord::Base.transaction do
        @position = Position.new(position_params)
        @position.complexity = Position.where(:technology_id => position_params[:technology_id]).count + 1
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
      @positions = Position.order("technology_id ASC, complexity ASC, title ASC").paginate(page: params[:page])
      @technologies = Technology.order("title ASC")
      format.js
    end
  end

  def update
    @position = Position.find_by_id(params[:id])
    if Position.where(:title => position_params[:title], :technology_id => position_params[:technology_id]).where.not(:id => params[:id]).count > 0
      @notif_type = 'info'
      @notif_message = t('position_already_exists')
    else
      ex_pos = Position.where(:technology_id => position_params[:technology_id], :complexity => position_params[:complexity]).where.not(:id => params[:id])
      if ex_pos.count > 0
        ex_pos.first.complexity = @position.complexity
        ex_pos.first.save
      end
      if @position.update_attributes(position_params)
        @notif_type = 'success'
        @notif_message = t('position_updated_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @positions = Position.order("technology_id ASC, complexity ASC, title ASC").paginate(page: params[:page])
      @technologies = Technology.order("title ASC")
      @item_id = @position.id
      format.js
    end
  end

  def destroy
    @current = Position.find(params[:id])
    pid = @current.id
    Position.find(params[:id]).destroy
    respond_to do |format|
      @positions = Position.order("technology_id ASC, complexity ASC, title ASC").paginate(page: params[:page])
      @technologies = Technology.order("title ASC")
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  def positions_update_complexity
    @item_id = params[:item_id]
    @complexity = ''
    @positions = Position.where(:technology_id => params[:technology_id])
    pos_counter = 1
    @positions.each do |pos|
      @complexity += "<option value='" + pos_counter.to_s + "'>" + pos_counter.to_s + "</option>"
      pos_counter += 1
    end
    respond_to do |format|
      format.js
    end
  end

  private

    def position_params
      params.require(:position).permit(:technology_id, :complexity, :title, :is_am, :is_pdm, :is_rated)
    end
end
