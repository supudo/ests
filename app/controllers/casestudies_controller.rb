class CasestudiesController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.casestudies_index'), :casestudies_path
    @filterrific = initialize_filterrific(
      Casestudy,
      params[:filterrific],
      :select_options => {
        sorted_by: Casestudy.options_for_sorted_by
      }
    ) or return
    @casestudies = @filterrific.find.page(params[:page]).order("title ASC")
    @projects = Project.order("title ASC")
    @casestudy = Casestudy.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.casestudies_index'), :casestudies_path
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @casestudy = Casestudy.find(params[:id])
    @projects = Project.order("title ASC")
    @cs_overviews = CasestudyOverview.where(:case_study_id => params[:id]).order("position ASC")
    @cs_challenges = CasestudyChallenge.where(:case_study_id => params[:id]).order("position ASC")
    @cs_solutions = CasestudySolution.where(:case_study_id => params[:id]).order("position ASC")
    @cs_technologies = CasestudyTechnology.where(:case_study_id => params[:id]).order("position ASC")
    @cs_links = CasestudyLink.where(:case_study_id => params[:id]).order("position ASC")
    @casestudy_ratio = {
      t('casestudies_overviews') => @cs_overviews.count,
      t('casestudies_challenges') => @cs_challenges.count,
      t('casestudies_solutions') => @cs_solutions.count,
      t('casestudies_technologies') => @cs_technologies.count,
      t('casestudies_overviews') => @cs_links.count,
    }
    render 'edit'
  end

  def create
    if Casestudy.where(:title => casestudy_params[:title], :project_id => casestudy_params[:project_id]).count > 0
      @notif_type = 'warning'
      @notif_message = t('casestudy_already_exists')
    else
      @casestudy = Casestudy.new(casestudy_params)
      @casestudy.created_user_id = current_user.id
      @casestudy.created_date = DateTime.now
      if @casestudy.save
        @notif_type = 'success'
        @notif_message = t('casestudy_created_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      @casestudies = Casestudy.order("title ASC").paginate(page: params[:page])
      @projects = Project.order("title ASC")
      @casestudy = Casestudy.new
      format.js
    end
  end

  def update
    @casestudy = Casestudy.find_by_id(params[:id])
    if Casestudy.where(:title => casestudy_params[:title], :project_id => casestudy_params[:project_id]).where.not(:id => params[:id]).count > 0
      @notif_type = 'info'
      @notif_message = t('casestudy_already_exists')
    else

      has_image = false
      if @casestudy.header_image != '' && !@casestudy.header_image.nil?
        @casestudy.title = casestudy_params[:title]
        @casestudy.description = casestudy_params[:description]
        if @casestudy.save
          @notif_type = 'success'
          @notif_message = t('casestudy_updated_successfully')
        else
          @notif_type = 'danger'
          @notif_message = t('error_missing_fields')
        end
        @himage = '/casestudies/' + @casestudy.header_image
      else
        if request.xhr? || remotipart_submitted?
          sleep 1 if params[:pause]
          f = params[:header_image]
          if !f.nil? && (File.extname(f.original_filename) == '.png' || File.extname(f.original_filename) == '.jpg' || File.extname(f.original_filename) == '.jpeg')
            File.open(Rails.root.join('public', 'casestudies', @casestudy.id.to_s + '_' + f.original_filename), 'wb') do |file|
              file.write(f.read)
              @casestudy.header_image = @casestudy.id.to_s + '_' + f.original_filename
              @casestudy.title = casestudy_params[:title]
              if @casestudy.save
                @himage = '/casestudies/' + @casestudy.id.to_s + '_' + f.original_filename
                @notif_type = 'success'
                @notif_message = t('casestudy_updated_successfully')
              else
                @notif_type = 'danger'
                @notif_message = t('error_missing_fields')
              end
            end
          else
            @notif_type = 'danger'
            @notif_message = t('invalid_image')
          end
        else
          @notif_type = 'danger'
          @notif_message = t('image_required')
        end
      end

    end
    respond_to do |format|
      @casestudies = Casestudy.order("title ASC").paginate(page: params[:page])
      @projects = Project.order("title ASC")
      @item_id = params[:id]
      @casestudy = Casestudy.new
      format.js
    end
  end

  def destroy
    cs = Casestudy.find_by_id(params[:id])
    File.delete(Rails.root.join('public', 'casestudies', cs.header_image))
    Casestudy.find(params[:id]).destroy
    respond_to do |format|
      @casestudies = Casestudy.order("title ASC").paginate(page: params[:page])
      @projects = Project.order("title ASC")
      @casestudy = Casestudy.new
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  private

    def casestudy_params
      params.require(:casestudy).permit(:project_id, :title, :description)
    end
end
