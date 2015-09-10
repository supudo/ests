class TechnologiesController < ApplicationController
  before_filter do |controller|
    controller.signed_in_user_permission("technologies")
  end

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.technologies_index'), :technologies_path
    @technology = Technology.new
    @technologies = Technology.where(:parent_id => 0).order("title ASC").paginate(page: params[:page])
  end

  def create
    if Technology.exists?(:title => technology_params[:title], :parent_id => 0)
      @notif_type = 'info'
      @notif_message = t('technology_already_exists')
    else
      ActiveRecord::Base.transaction do
        @technology = Technology.new(technology_params)
        if @technology.save
          @notif_type = 'success'
          @notif_message = t('technology_created_successfully')
        else
          @notif_type = 'danger'
          @notif_message = t('error_missing_fields')
        end
      end
    end
    respond_to do |format|
      @technologies = Technology.where(:parent_id => 0).order("title ASC").paginate(page: params[:page])
      format.js
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @technology = Technology.find_by_id(params[:id])
      if Technology.where(:title => technology_params[:title], :parent_id => 0).where.not(:id => params[:id]).count > 0
        @notif_type = 'info'
        @notif_message = t('technology_already_exists')
      else
        if @technology.update_attributes(technology_params)
          @notif_type = 'success'
          @notif_message = t('technology_updated_successfully')
        else
          @notif_type = 'danger'
          @notif_message = t('error_missing_fields')
        end
      end
      respond_to do |format|
        @technologies = Technology.where(:parent_id => 0).order("title ASC").paginate(page: params[:page])
        @item_id = @technology.id
        format.js
      end
    end
  end

  def destroy
    @current = Technology.find(params[:id])
    pid = @current.id
    Technology.find(params[:id]).destroy
    RatesPrice.where(:technology_id => params[:id]).destroy_all
    respond_to do |format|
      @technologies = Technology.where(:parent_id => 0).order("title ASC").paginate(page: params[:page])
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  # --------------------------------
  # Tree
  # --------------------------------

  def techtree
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.technologies_index'), :technologies_path
    add_breadcrumb I18n.t('breadcrumbs.technologies_index')
  end

  def deletetechnode
    @current = Technology.find(params[:tid])
    pid = @current.id
    Technology.find(params[:tid]).destroy
    RatesPrice.where(:technology_id => params[:tid]).destroy_all
    tech_nodes = getTechTree()
    respond_to do |format|
      format.html
      format.json { render :json => tech_nodes.to_json }
    end
  end

  def updatetechnode
    technology = Technology.find_by_id(params[:tid])
    ActiveRecord::Base.transaction do
      if Technology.where(:title => params[:name], :parent_id => params[:parent]).where.not(:id => params[:tid]).count == 0
        technology.title = params[:name]
        technology.save
      end
    end
    child = {}
    child[:id] = technology.id
    child[:name] = technology.title
    child[:level] = getNodeLevel(technology, 0)
    child[:type] = "default"
    respond_to do |format|
      format.html
      format.json { render :json => child.to_json }
    end
  end

  def deletefromtree
    @current = Technology.find(params[:tid])
    pid = @current.id
    Technology.find(params[:tid]).destroy
    RatesPrice.where(:technology_id => params[:tid]).destroy_all
    params[:id] = params[:tid]
    tech_nodes = getTechTree()
    respond_to do |format|
      format.html
      format.json { render :json => tech_nodes.to_json }
    end
  end

  def createtechnode
    if Technology.exists?(:title => params[:name], :parent_id => [:parent])
      @notif_type = 'info'
      @notif_message = t('technology_already_exists')
    else
      technology = Technology.new
      technology.title = params[:name]
      technology.parent_id = params[:parent]
      technology.is_rated = 0
      technology.save
    end
    child = {}
    child[:id] = technology.id
    child[:name] = technology.title
    child[:level] = getNodeLevel(technology, 0)
    child[:type] = "default"
    respond_to do |format|
      format.html
      format.json { render :json => child.to_json }
    end
  end

  def techtreegrid
    tech_nodes = getTechTree()
    respond_to do |format|
      format.html
      format.json { render :json => tech_nodes.to_json }
    end
  end

  def techtreedetails
    respond_to do |format|
      @technology = Technology.find(params[:tid])
      format.js
    end
  end

  private

    def getTechTree
      tech_tree = []
      technologies = Technology.where(:parent_id => params[:id]).order("title")
      technologies.each do |tech|
        child = {}
        child[:id] = tech.id
        child[:name] = tech.title
        child[:level] = getNodeLevel(tech, 0)
        child[:type] = "default"
        children = techTreeGrid(child, tech.id, 1)
        if !children.nil? && children.count > 0
          child[:nodes] = children
        end
        tech_tree.push(child)
      end
      tech_nodes = {}
      tech_nodes[:nodes] = tech_tree
      return tech_nodes
    end

    def techTreeGrid(dataTree, parent_id, level)
      technologies = Technology.where(:parent_id => parent_id).order("title")
      nodes = []
      technologies.each do |tech|
        child = {}
        child[:id] = tech.id
        child[:name] = tech.title
        child[:level] = getNodeLevel(tech, 0)
        child[:type] = "default"
        children = techTreeGrid(child, tech.id, (level + 1))
        if !children.nil? && children.count > 0
          child[:nodes] = children
        end
        nodes.push(child)
      end
      return nodes
    end

    def getNodeLevel(node, level)
      if node.parent.nil?
        return level
      else
        return getNodeLevel(node.parent, (level + 1))
      end
    end

    def technology_params
      params.require(:technology).permit(:title, :style, :is_rated)
    end
end
