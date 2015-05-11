class AboutController < ApplicationController

  def index
    add_breadcrumb I18n.t('about'), about_index_path
  end

end
