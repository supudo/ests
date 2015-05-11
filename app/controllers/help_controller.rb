class HelpController < ApplicationController

  def index
    add_breadcrumb I18n.t('help'), help_index_path
  end

end
