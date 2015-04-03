class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include LoginHelper

  before_action :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = t('access_denied_msg')
    redirect_to root_path and return
  end
 
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    Rails.application.routes.default_url_options[:locale]= I18n.locale 
  end

  protected
 
    #derive the model name from the controller. egs UsersController will return User
    def self.permission
      return name = self.name.gsub('Controller','').singularize.split('::').last.constantize.name rescue nil
    end
 
    def current_ability
      @current_ability ||= Ability.new(current_user)
    end
 
    #load the permissions for the current user so that UI can be manipulated
    def load_permissions
      @current_permissions = current_user.role.permissions.collect{|i| [i.subject_class, i.action]}
    end

end
