class PositionsController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.positions_index'), positions_path
    @positions = Position.order("title ASC").paginate(page: params[:page], :per_page => 10)
  end

  def new
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.positions_index'), positions_path
    add_breadcrumb I18n.t('breadcrumbs.new')
    @position = Position.new
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.positions_index'), positions_path
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @position = Position.find(params[:id])
    render 'edit'
  end

  def create
    if Position.exists?(:title => position_params[:title])
      flash[:success] = t('position_already_exists')
      redirect_to :new_project
    else
      ActiveRecord::Base.transaction do
        @position = Position.new(position_params)
        if @position.save
          flash[:success] = t('position_created_successfully')
          redirect_to :collections
        else
          add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
          add_breadcrumb I18n.t('breadcrumbs.positions_index'), positions_path
          add_breadcrumb I18n.t('breadcrumbs.new')
          @position = Position.new
          flash[:error] = t('error_missing_fields')
          render 'new'
        end
      end
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @position = Position.find_by_id(params[:id])
      if @position.update_attributes(position_params)
        flash[:success] = t('position_updated_successfully')
        redirect_to :collections
      else
        add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
        add_breadcrumb I18n.t('breadcrumbs.positions_index'), positions_path
        add_breadcrumb I18n.t('breadcrumbs.edit')
        @position = Position.new
        flash[:error] = t('error_missing_fields')
        render 'edit'
      end
    end
  end

  def destroy
    @current = Position.find(params[:id])
    pid = @current.id
    Position.find(params[:id]).destroy
    respond_to do |format|
      @positions = Position.order("title ASC").paginate(page: params[:page], :per_page => 10)
      format.js
    end
  end

  private

    def position_params
      params.require(:position).permit(:title, :is_am, :is_pdm)
    end
end
