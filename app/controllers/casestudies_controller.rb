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

      @casestudy.title = casestudy_params[:title]
      @casestudy.description = casestudy_params[:description]
      if @casestudy.save
        @notif_type = 'success'
        @notif_message = t('casestudy_updated_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end

      image_error = false
      if request.xhr? || remotipart_submitted?
        sleep 1 if params[:pause]
        f = params[:header_image]
        if f.nil?
          image_error = true
          @notif_type = 'danger'
          @notif_message = t('image_required')
        elsif !f.nil? && (File.extname(f.original_filename) == '.png' || File.extname(f.original_filename) == '.jpg' || File.extname(f.original_filename) == '.jpeg')
          File.open(Rails.root.join('public', 'casestudies', @casestudy.id.to_s + '_' + f.original_filename), 'wb') do |file|
            file.write(f.read)
            @casestudy.header_image = @casestudy.id.to_s + '_' + f.original_filename
            @casestudy.title = casestudy_params[:title]
            if @casestudy.save
              @notif_type = 'success'
              @notif_message = t('casestudy_updated_successfully')
            else
              @notif_type = 'danger'
              @notif_message = t('error_missing_fields')
            end
          end
        else
          image_error = true
          @notif_type = 'danger'
          @notif_message = t('invalid_image')
        end
      end

      if !image_error && (@casestudy.header_image == '' || @casestudy.header_image.nil?)
        @notif_type = 'danger'
        @notif_message = t('image_required')
      end

    end

    respond_to do |format|
      if @casestudy.header_image != '' && !@casestudy.header_image.nil?
        @himage = '/casestudies/' + @casestudy.header_image
      else
        @himage = '/casestudies/spacer.png'
      end
      @casestudies = Casestudy.order("title ASC").paginate(page: params[:page])
      @projects = Project.order("title ASC")
      @item_id = params[:id]
      @casestudy = Casestudy.new
      format.js
    end
  end

  def destroy
    cs = Casestudy.find_by_id(params[:id])
    if cs.header_image != '' && !cs.header_image.nil?
      File.delete(Rails.root.join('public', 'casestudies', cs.header_image))
    end
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

  def export_casestudy_pdf
    @cs = Casestudy.find_by_id(params[:case_study_id])
    @cs_header_image = Rails.root.join('public', 'casestudies', @cs.header_image)
    @cs_overviews = CasestudyOverview.where(:case_study_id => @cs.id).order("position ASC")
    @cs_challenges = CasestudyChallenge.where(:case_study_id => @cs.id).order("position ASC")
    @cs_solutions = CasestudySolution.where(:case_study_id => @cs.id).order("position ASC")
    @cs_technologies = CasestudyTechnology.where(:case_study_id => @cs.id).order("position ASC")
    @cs_links = CasestudyLink.where(:case_study_id => @cs.id).order("position ASC")

    pdf_file = Rails.root.join('public', 'exports', sanitize_filename(@cs.title) + '.pdf')

    if !File.exist?(pdf_file) || params[:regenerate] == 'true'
      render :pdf => pdf_file,
             :template => 'casestudies/pdf_template.html.erb',
             :save_to_file => pdf_file,
             :save_only => true,
             :disposition => 'attachment',
             :encoding => 'UTF-8'
    end

    send_file pdf_file
  end

  def sanitize_filename(filename)
    return filename.strip do |name|
      name.gsub!(/^.*(\\|\/)/, '')
      name.gsub!(/[^0-9A-Za-z.\-]/, '_')
    end
  end

  private

    def casestudy_params
      params.require(:casestudy).permit(:project_id, :title, :description, :text_color)
    end
end
