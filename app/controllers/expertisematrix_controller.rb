class ExpertisematrixController < ApplicationController
  before_filter do |controller|
    controller.signed_in_user_permission("technologies")
  end

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.technologies_index'), :technologies_path
    add_breadcrumb I18n.t('breadcrumbs.expertise_matrix_index')
  end

  def emtechtreegrid
    tech_nodes = getTechTree()
    respond_to do |format|
      format.html
      format.json { render :json => tech_nodes.to_json }
    end
  end

  def emtechtreedetails
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
        users_string = ''
        users_per_tech = ActiveRecord::Base.connection.execute(%{SELECT
  u.id, u.first_name, u.last_name,
  (
    SELECT GROUP_CONCAT(t.title)
    FROM
      technologies AS t
      INNER JOIN users_competencies AS uc2 ON uc2.technology_id = t.id
    WHERE uc2.user_id = u.id
  ) AS user_skills
FROM
  users_competencies AS uc
  INNER JOIN users AS u ON u.id = uc.user_id
WHERE uc.technology_id = } + tech.id.to_s)
        users_per_tech.each do |u|
          users_string += '<a href="/users/' + u[0].to_s + '" data-toggle="tooltip" data-placement="bottom" title="' + u[3] + '">' + u[1] + ' ' + u[2] + '</a>, '
        end
        if users_string.size > 2
          users_string = users_string[0, users_string.size - 2]
        end
        child = {}
        child[:id] = tech.id
        if users_per_tech.count > 0
          child[:name] = tech.title + ' - <u><b>' + users_per_tech.count.to_s + '</b></u> (' + users_string + ')'
        else
          child[:name] = tech.title
        end
        child[:level] = getNodeLevel(tech, 0)
        tech_type = 'default'
        if tech.parent_id == 0
          tech_type = 'default'
        elsif !tech.children.nil? && tech.children.count > 0
          tech_type = 'category'
        else
          tech_type = 'tech'
        end
        child[:type] = tech_type
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

end
