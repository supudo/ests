class EstimateImporterController < ApplicationController
  before_action :signed_in_user
  require 'roo'

  def new
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.estimates_importer_index'), new_estimate_importer_path
  end

  def import
    # open file
    f = params[:imported_file]
    case File.extname(f.original_filename)
      when ".csv" then spreadsheet = Roo::Csv.new(f.path, nil, :ignore)
      when ".xls" then spreadsheet = Roo::Excel.new(f.path, nil, :ignore)
      when ".xlsx" then spreadsheet = Roo::Excelx.new(f.path, nil, :ignore)
      else raise "Unknown file type: #{f.original_filename}"
    end
    sheet = spreadsheet.sheet(0)

    # General info
    @info = {}
    @info["client"] = sheet.cell(1, 2)
    @info["project"] = sheet.cell(2, 2)

    # Assumptions
    assumptions = []
    row_counter = 6
    while true
      assmpt = sheet.cell(row_counter, 2)

      if (assmpt != 'Task' && assmpt != nil && assmpt != '')
        assumptions.push(assmpt)
        row_counter += 1
      else
        break
      end
    end
    @info["assumptions"] = assumptions


    
    render 'new'
  end
end
