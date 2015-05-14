class CasestudiesitemsController < ApplicationController
  before_action :signed_in_user

# Overviews
  def add_overview
    if CasestudyOverview.where(:title => casestudy_overview_params[:title], :case_study_id => casestudy_overview_params[:case_study_id]).count > 0
      @notif_type = 'warning'
      @notif_message = t('item_exists')
    else
      @cso = CasestudyOverview.new(casestudy_overview_params)
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

# Challenges
  def add_challenge
    if CasestudyChallenge.where(:title => casestudy_challenges_params[:title], :case_study_id => casestudy_challenges_params[:case_study_id]).count > 0
      @notif_type = 'warning'
      @notif_message = t('item_exists')
    else
      @csc = CasestudyChallenge.new(casestudy_challenges_params)
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

# Solutions
  def add_solution
    if CasestudySolution.where(:title => casestudy_solutions_params[:title], :case_study_id => casestudy_solutions_params[:case_study_id]).count > 0
      @notif_type = 'warning'
      @notif_message = t('item_exists')
    else
      @css = CasestudySolution.new(casestudy_solutions_params)
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

# Technologies
  def add_technology
    if CasestudyTechnology.where(:title => casestudy_technologies_params[:title], :case_study_id => casestudy_technologies_params[:case_study_id]).count > 0
      @notif_type = 'warning'
      @notif_message = t('item_exists')
    else
      @cst = CasestudyTechnology.new(casestudy_technologies_params)
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
end
