class CasestudiesitemsController < ApplicationController
  before_filter do |controller|
    controller.signed_in_user_permission("case_studies")
  end

# ========================================================================
# Overviews
# ========================================================================
  def add_overview
    if CasestudyOverview.where(:title => casestudy_overview_params[:title], :case_study_id => casestudy_overview_params[:case_study_id]).count > 0
      @notif_type = 'warning'
      @notif_message = t('item_exists')
    else
      c = CasestudyOverview.where("case_study_id = ?", casestudy_overview_params[:case_study_id]).count
      @cso = CasestudyOverview.new(casestudy_overview_params)
      @cso.position = c + 1
      if @cso.save
        @notif_type = 'success'
        @notif_message = t('item_created')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @cs_overviews = CasestudyOverview.where(:case_study_id => casestudy_overview_params[:case_study_id]).order("position ASC")
      format.js
    end
  end

  def update_overview
    @cso = CasestudyOverview.find_by_id(params[:cso_id])
    if CasestudyOverview.where(:title => casestudy_overview_params[:title], :case_study_id => casestudy_overview_params[:case_study_id]).where.not(:id => params[:cso_id]).count > 0
      @notif_type = 'warning'
      @notif_message = t('item_exists')
    else
      if @cso.update_attributes(casestudy_overview_params)
        @notif_type = 'success'
        @notif_message = t('item_updated')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @cs_overviews = CasestudyOverview.where(:case_study_id => casestudy_overview_params[:case_study_id]).order("position ASC")
      format.js
    end
  end

  def destroy_overview
    CasestudyOverview.find(params[:cso_id]).destroy
    respond_to do |format|
      @cs_overviews = CasestudyOverview.where(:case_study_id => params[:case_study_id]).order("position ASC")
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  def moveup_overview
    @current = CasestudyOverview.find(params[:id])
    @above = CasestudyOverview.order("position DESC").where("position < ? AND case_study_id = ?", @current.position, @current.case_study_id).first
    pos = @above.position
    @above.position = @current.position
    @above.save
    @current.position = pos
    @current.save
    respond_to do |format|
      @cs_overviews = CasestudyOverview.where(:case_study_id => @current.case_study_id).order("position ASC")
      format.js
    end
  end

  def movedown_overview
    @current = CasestudyOverview.find(params[:id])
    @bellow = CasestudyOverview.order("position ASC").where("position > ? AND case_study_id = ?", @current.position, @current.case_study_id).first
    pos = @bellow.position
    @bellow.position = @current.position
    @bellow.save
    @current.position = pos
    @current.save
    respond_to do |format|
      @cs_overviews = CasestudyOverview.where(:case_study_id => @current.case_study_id).order("position ASC")
      format.js
    end
  end

# ========================================================================
# Challenges
# ========================================================================
  def add_challenge
    if CasestudyChallenge.where(:title => casestudy_challenges_params[:title], :case_study_id => casestudy_challenges_params[:case_study_id]).count > 0
      @notif_type = 'warning'
      @notif_message = t('item_exists')
    else
      c = CasestudyChallenge.where("case_study_id = ?", casestudy_challenges_params[:case_study_id]).count
      @csc = CasestudyChallenge.new(casestudy_challenges_params)
      @csc.position = c + 1
      if @csc.save
        @notif_type = 'success'
        @notif_message = t('item_created')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @cs_challenges = CasestudyChallenge.where(:case_study_id => casestudy_challenges_params[:case_study_id]).order("position ASC")
      format.js
    end
  end

  def update_challenge
    @csc = CasestudyChallenge.find_by_id(params[:cso_id])
    if CasestudyChallenge.where(:title => casestudy_challenges_params[:title], :case_study_id => casestudy_challenges_params[:case_study_id]).where.not(:id => params[:cso_id]).count > 0
      @notif_type = 'warning'
      @notif_message = t('item_exists')
    else
      if @csc.update_attributes(casestudy_challenges_params)
        @notif_type = 'success'
        @notif_message = t('item_updated')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @cs_challenges = CasestudyChallenge.where(:case_study_id => casestudy_challenges_params[:case_study_id]).order("position ASC")
      format.js
    end
  end

  def destroy_challenge
    CasestudyChallenge.find(params[:cso_id]).destroy
    respond_to do |format|
      @cs_challenges = CasestudyChallenge.where(:case_study_id => params[:case_study_id]).order("position ASC")
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  def moveup_challenge
    @current = CasestudyChallenge.find(params[:id])
    @above = CasestudyChallenge.order("position DESC").where("position < ? AND case_study_id = ?", @current.position, @current.case_study_id).first
    pos = @above.position
    @above.position = @current.position
    @above.save
    @current.position = pos
    @current.save
    respond_to do |format|
      @cs_overviews = CasestudyChallenge.where(:case_study_id => @current.case_study_id).order("position ASC")
      format.js
    end
  end

  def movedown_challenge
    @current = CasestudyChallenge.find(params[:id])
    @bellow = CasestudyChallenge.order("position ASC").where("position > ? AND case_study_id = ?", @current.position, @current.case_study_id).first
    pos = @bellow.position
    @bellow.position = @current.position
    @bellow.save
    @current.position = pos
    @current.save
    respond_to do |format|
      @cs_overviews = CasestudyChallenge.where(:case_study_id => @current.case_study_id).order("position ASC")
      format.js
    end
  end

# ========================================================================
# Solutions
# ========================================================================
  def add_solution
    if CasestudySolution.where(:title => casestudy_solutions_params[:title], :case_study_id => casestudy_solutions_params[:case_study_id]).count > 0
      @notif_type = 'warning'
      @notif_message = t('item_exists')
    else
      c = CasestudySolution.where("case_study_id = ?", casestudy_solutions_params[:case_study_id]).count
      @css = CasestudySolution.new(casestudy_solutions_params)
      @css.position = c + 1
      if @css.save
        @notif_type = 'success'
        @notif_message = t('item_created')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @cs_solutions = CasestudySolution.where(:case_study_id => casestudy_solutions_params[:case_study_id]).order("position ASC")
      format.js
    end
  end

  def update_solution
    @css = CasestudySolution.find_by_id(params[:cso_id])
    if CasestudySolution.where(:title => casestudy_solutions_params[:title], :case_study_id => casestudy_solutions_params[:case_study_id]).where.not(:id => params[:cso_id]).count > 0
      @notif_type = 'warning'
      @notif_message = t('item_exists')
    else
      if @css.update_attributes(casestudy_solutions_params)
        @notif_type = 'success'
        @notif_message = t('item_updated')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @cs_solutions = CasestudySolution.where(:case_study_id => casestudy_solutions_params[:case_study_id]).order("position ASC")
      format.js
    end
  end

  def destroy_solution
    CasestudySolution.find(params[:cso_id]).destroy
    respond_to do |format|
      @cs_solutions = CasestudySolution.where(:case_study_id => params[:case_study_id]).order("position ASC")
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  def moveup_solution
    @current = CasestudySolution.find(params[:id])
    @above = CasestudySolution.order("position DESC").where("position < ? AND case_study_id = ?", @current.position, @current.case_study_id).first
    pos = @above.position
    @above.position = @current.position
    @above.save
    @current.position = pos
    @current.save
    respond_to do |format|
      @cs_overviews = CasestudySolution.where(:case_study_id => @current.case_study_id).order("position ASC")
      format.js
    end
  end

  def movedown_solution
    @current = CasestudySolution.find(params[:id])
    @bellow = CasestudySolution.order("position ASC").where("position > ? AND case_study_id = ?", @current.position, @current.case_study_id).first
    pos = @bellow.position
    @bellow.position = @current.position
    @bellow.save
    @current.position = pos
    @current.save
    respond_to do |format|
      @cs_overviews = CasestudySolution.where(:case_study_id => @current.case_study_id).order("position ASC")
      format.js
    end
  end

# ========================================================================
# Technologies
# ========================================================================
  def add_technology
    if CasestudyTechnology.where(:title => casestudy_technologies_params[:title], :case_study_id => casestudy_technologies_params[:case_study_id]).count > 0
      @notif_type = 'warning'
      @notif_message = t('item_exists')
    else
      c = CasestudyTechnology.where("case_study_id = ?", casestudy_technologies_params[:case_study_id]).count
      @cst = CasestudyTechnology.new(casestudy_technologies_params)
      @cst.position = c + 1
      if @cst.save
        @notif_type = 'success'
        @notif_message = t('item_created')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @cs_technologies = CasestudyTechnology.where(:case_study_id => casestudy_technologies_params[:case_study_id]).order("position ASC")
      format.js
    end
  end

  def update_technology
    @cst = CasestudyTechnology.find_by_id(params[:cso_id])
    if CasestudyTechnology.where(:title => casestudy_technologies_params[:title], :case_study_id => casestudy_technologies_params[:case_study_id]).where.not(:id => params[:cso_id]).count > 0
      @notif_type = 'warning'
      @notif_message = t('item_exists')
    else
      if @cst.update_attributes(casestudy_technologies_params)
        @notif_type = 'success'
        @notif_message = t('item_updated')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @cs_technologies = CasestudyTechnology.where(:case_study_id => casestudy_technologies_params[:case_study_id]).order("position ASC")
      format.js
    end
  end

  def destroy_technology
    CasestudyTechnology.find(params[:cso_id]).destroy
    respond_to do |format|
      @cs_technologies = CasestudyTechnology.where(:case_study_id => params[:case_study_id]).order("position ASC")
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  def moveup_technology
    @current = CasestudyTechnology.find(params[:id])
    @above = CasestudyTechnology.order("position DESC").where("position < ? AND case_study_id = ?", @current.position, @current.case_study_id).first
    pos = @above.position
    @above.position = @current.position
    @above.save
    @current.position = pos
    @current.save
    respond_to do |format|
      @cs_overviews = CasestudyTechnology.where(:case_study_id => @current.case_study_id).order("position ASC")
      format.js
    end
  end

  def movedown_technology
    @current = CasestudyTechnology.find(params[:id])
    @bellow = CasestudyTechnology.order("position ASC").where("position > ? AND case_study_id = ?", @current.position, @current.case_study_id).first
    pos = @bellow.position
    @bellow.position = @current.position
    @bellow.save
    @current.position = pos
    @current.save
    respond_to do |format|
      @cs_overviews = CasestudyTechnology.where(:case_study_id => @current.case_study_id).order("position ASC")
      format.js
    end
  end

# ========================================================================
# Links
# ========================================================================
  def add_link
    if CasestudyLink.where(:title => casestudy_links_params[:title], :case_study_id => casestudy_links_params[:case_study_id]).count > 0
      @notif_type = 'warning'
      @notif_message = t('item_exists')
    else
      c = CasestudyLink.where("case_study_id = ?", casestudy_links_params[:case_study_id]).count
      @csl = CasestudyLink.new(casestudy_links_params)
      @csl.position = c + 1
      if @csl.save
        @notif_type = 'success'
        @notif_message = t('item_created')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @cs_links = CasestudyLink.where(:case_study_id => casestudy_links_params[:case_study_id]).order("position ASC")
      format.js
    end
  end

  def update_link
    @csl = CasestudyLink.find_by_id(params[:cso_id])
    if CasestudyLink.where(:title => casestudy_links_params[:title], :case_study_id => casestudy_links_params[:case_study_id]).where.not(:id => params[:cso_id]).count > 0
      @notif_type = 'warning'
      @notif_message = t('item_exists')
    else
      if @csl.update_attributes(casestudy_links_params)
        @notif_type = 'success'
        @notif_message = t('item_updated')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @cs_links = CasestudyLink.where(:case_study_id => casestudy_links_params[:case_study_id]).order("position ASC")
      format.js
    end
  end

  def destroy_link
    CasestudyLink.find(params[:cso_id]).destroy
    respond_to do |format|
      @cs_links = CasestudyLink.where(:case_study_id => params[:case_study_id]).order("position ASC")
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  def moveup_link
    @current = CasestudyLink.find(params[:id])
    @above = CasestudyLink.order("position DESC").where("position < ? AND case_study_id = ?", @current.position, @current.case_study_id).first
    pos = @above.position
    @above.position = @current.position
    @above.save
    @current.position = pos
    @current.save
    respond_to do |format|
      @cs_links = CasestudyLink.where(:case_study_id => @current.case_study_id).order("position ASC")
      format.js
    end
  end

  def movedown_link
    @current = CasestudyLink.find(params[:id])
    @bellow = CasestudyLink.order("position ASC").where("position > ? AND case_study_id = ?", @current.position, @current.case_study_id).first
    pos = @bellow.position
    @bellow.position = @current.position
    @bellow.save
    @current.position = pos
    @current.save
    respond_to do |format|
      @cs_links = CasestudyLink.where(:case_study_id => @current.case_study_id).order("position ASC")
      format.js
    end
  end

# ========================================================================
# Private
# ========================================================================
  private

    def casestudy_overview_params
      params.require(:casestudy_overview).permit(:cso_id, :case_study_id, :title)
    end

    def casestudy_challenges_params
      params.require(:casestudy_challenge).permit(:cso_id, :case_study_id, :title)
    end

    def casestudy_solutions_params
      params.require(:casestudy_solution).permit(:cso_id, :case_study_id, :title)
    end

    def casestudy_technologies_params
      params.require(:casestudy_technology).permit(:cso_id, :case_study_id, :title)
    end

    def casestudy_links_params
      params.require(:casestudy_link).permit(:cso_id, :case_study_id, :title)
    end
end
