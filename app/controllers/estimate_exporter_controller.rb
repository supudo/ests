class EstimateExporterController < ApplicationController
  before_action :signed_in_user

  def index
    estimate = Estimate.find(params[:estimate_id])
    sheets = EstimatesSheet.where(:estimate_id => params[:estimate_id]).order("id ASC")
    assumptions = EstimatesAssumption.where(:estimate_id => params[:estimate_id]).order("title ASC")

    file_client = Client.find(estimate.client_id).title
    file_project = Project.find(estimate.project_id).title

    estimate_file = Axlsx::Package.new

    # Estimate sheet
    f_workbook = estimate_file.workbook
    f_sheet = f_workbook.add_worksheet(:name => t('export_general_sheet'))

    # Styles
    cs_black = f_workbook.styles.add_style :bg_color => "4C", :fg_color => "FF", :alignment => { :horizontal=> :left }, :b => true
    cs_black_right = f_workbook.styles.add_style :bg_color => "4C", :fg_color => "FF", :alignment => { :horizontal=> :right }, :b => true
    cs_grey = f_workbook.styles.add_style :bg_color => "CC", :fg_color => "00", :alignment => { :horizontal=> :left }, :b => true
    cs_bold = f_workbook.styles.add_style :b => true, :alignment => { :horizontal=> :left }
    cs_normal = f_workbook.styles.add_style :alignment => { :horizontal=> :left }

    #General
    f_sheet.add_row [t('client'), file_client], :style => [cs_bold, nil]
    f_sheet.add_row [t('project'), file_project], :style => [cs_bold, nil]
    f_sheet.add_row [t('export_date'), Time.now.strftime("%d/%m/%Y")], :style => [cs_bold, nil]
    f_sheet.add_row [t('export_version'), 1], :style => [cs_bold, cs_normal]
    f_sheet.add_row []

    # Assumptions
    c = 0
    assumptions.each do |f_assumption|
      if c == 0
        f_sheet.add_row [t('assumptions'), f_assumption.title], :style => [cs_bold, nil]
      end
      f_sheet.add_row ['', f_assumption.title]
      c += 1
    end
    f_sheet.add_row []
      
    f_sheet.add_row ['', t('estimate_task'), t('estimate_hours_min'), t('estimate_hours_max'), t('estimate_rate'), t('estimate_cost_min'), t('estimate_cost_max')], :style => [nil, cs_black, cs_black, cs_black, cs_black, cs_black, cs_black]
    f_sheet.add_row [], :style => [nil, cs_black, cs_black, cs_black, cs_black, cs_black, cs_black]

    estimate_total_hours_min = 0
    estimate_total_hours_max = 0
    # Sheets
    sheets.each do |sheet|

      f_sheet.add_row ['', sheet.title, '', '', '', '', ''], :style => [nil, cs_black, cs_black, cs_black, cs_black, cs_black, cs_black]

      # Sections
      sections = EstimatesSection.where(:estimates_sheet_id => sheet.id).order("id ASC")
      sections.each do |f_section|
        f_sheet.add_row ['', f_section.title, f_section.total_min_hours, f_section.total_max_hours, '', '', ''], :style => [nil, cs_grey, cs_grey, cs_grey, cs_grey, cs_grey, cs_grey]
        estimate_total_hours_min += f_section.total_min_hours
        estimate_total_hours_max += f_section.total_max_hours

        # Lines
        lines = EstimatesLine.where(:estimates_sections_id => f_section.id).order("line_number ASC")
        lines.each do |f_line|
          f_sheet.add_row ['', f_line.line, f_line.hours_min, f_line.hours_max, '', '', ''], :style => [nil, cs_normal, cs_normal, cs_normal, cs_normal, cs_normal, cs_normal]
        end

      end

    end
    f_sheet.add_row ['', t('total_caps'), estimate_total_hours_min, estimate_total_hours_max, '', '', ''], :style => [nil, cs_black_right, cs_black, cs_black, cs_black, cs_black, cs_black]
    
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
