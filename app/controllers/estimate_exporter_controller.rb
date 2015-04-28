class EstimateExporterController < ApplicationController
  before_action :signed_in_user

  def index
    estimate = Estimate.find(params[:estimate_id])
    sheets = EstimatesSheet.where(:estimate_id => params[:estimate_id]).order("id ASC")
    assumptions = EstimatesAssumption.where(:estimate_id => params[:estimate_id]).order("title ASC")
    #sections = EstimatesSection.where(:estimate_id => params[:estimate_id]).order("id ASC")
    #lines = EstimatesLine.where(:estimate_id => params[:estimate_id]).order("line_number ASC")

    file_client = Client.find(estimate.client_id).title
    file_project = Project.find(estimate.project_id).title

    estimate_file = Axlsx::Package.new

    # General sheet
    estimate_file.workbook.add_worksheet(:name => t('export_general_sheet')) do |f_sheet|

        f_sheet.add_row [t('client'), file_client]
        f_sheet.add_row [t('project'), file_project]
        f_sheet.add_row [t('export_date'), Time.now.strftime("%d/%m/%Y")]
        f_sheet.add_row [t('export_version'), '1']
        f_sheet.add_row []

        # Assumptions
        c = 0
        assumptions.each do |f_assumption|
          if c == 0
            f_sheet.add_row [t('assumptions'), f_assumption.title]
          end
          f_sheet.add_row ['', f_assumption.title]
          c += 1
        end
      
    end

    # Sheets
    sheets.each do |sheet|

      estimate_file.workbook.add_worksheet(:name => sheet.title) do |f_sheet|
        f_sheet.add_row ["First Column", "Second", "Third"]
        f_sheet.add_row [1, 2, 3]
      end

    end

    # Options
    estimate_file.use_shared_strings = true
    
    # File
    file_client = file_client.gsub(' ', '_').gsub('.', '_')
    file_project = file_project.gsub(' ', '_').gsub('.', '_')
    file_name = file_client + '_' + file_project + '_' + Time.now.strftime("%d%m%Y")
    file_name = 'public/exports/' + file_name + '.xlsx'
    estimate_file.serialize(file_name)

    # Download
    send_file file_name
  end

end
