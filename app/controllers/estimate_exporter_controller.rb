class EstimateExporterController < ApplicationController
  before_action :signed_in_user

  def index
    estimate = Estimate.find(params[:estimate_id])
    sheets = EstimatesSheet.where(:estimate_id => params[:estimate_id]).order("id ASC")
    assumptions = EstimatesAssumption.where(:estimate_id => params[:estimate_id]).order("title ASC")
    rate_prices = RatesPrice.where(:rate_id => estimate.rate_id, :engagement_model_id => estimate.engagement_model_id)
    currency_symbol = estimate.rate.currency.symbol

    file_client = Client.find(estimate.client_id).title
    file_project = Project.find(estimate.project_id).title

    estimate_file = Axlsx::Package.new

    # Estimate sheet
    f_workbook = estimate_file.workbook
    f_sheet = f_workbook.add_worksheet(:name => t('export_general_sheet'))

    # Styles
    cs_header = f_workbook.styles.add_style :bg_color => "4C", :fg_color => "FF", :alignment => { :horizontal=> :left, :vertical => :center }, :b => true
    cs_black = f_workbook.styles.add_style :bg_color => "4C", :fg_color => "FF", :alignment => { :horizontal=> :left }, :b => true
    cs_black_right = f_workbook.styles.add_style :bg_color => "4C", :fg_color => "FF", :alignment => { :horizontal=> :right }, :b => true
    cs_grey = f_workbook.styles.add_style :bg_color => "CC", :fg_color => "00", :alignment => { :horizontal=> :left }, :b => true
    cs_grey_dark = f_workbook.styles.add_style :bg_color => "80", :fg_color => "ff", :alignment => { :horizontal=> :left }, :b => true
    cs_bold = f_workbook.styles.add_style :b => true, :alignment => { :horizontal=> :left }
    cs_normal = f_workbook.styles.add_style :alignment => { :horizontal=> :left }

    # Styles - Borders
    defaults =  { :style => :medium, :color => "000000" }
    borders = Hash.new do |hash, key|
      hash[key] = f_workbook.styles.add_style :border => defaults.merge( { :edges => key.to_s.split('_').map(&:to_sym) } )
    end

    # Counters
    counter_row = 0

    #General
    f_sheet.add_row [t('client'), file_client], :style => [cs_bold, nil]
    f_sheet.add_row [t('project'), file_project], :style => [cs_bold, nil]
    f_sheet.add_row [t('export_date'), Time.now.strftime("%d/%m/%Y")], :style => [cs_bold, nil]
    f_sheet.add_row [t('export_version'), 1], :style => [cs_bold, cs_normal]
    f_sheet.add_row []
    counter_row += 5

    # Assumptions
    c = 0
    assumptions.each do |f_assumption|
      if c == 0
        f_sheet.merge_cells("B" + counter_row.to_s + ":G" + counter_row.to_s)
        f_sheet.add_row [t('assumptions'), f_assumption.title, '', '', '', '', '', ''], :style => [cs_bold, borders[:top_left], borders[:top], borders[:top], borders[:top], borders[:top], borders[:top], borders[:left]]
      else
        f_sheet.merge_cells("B" + counter_row.to_s + ":G" + counter_row.to_s)
        f_sheet.add_row ['', f_assumption.title, '', '', '', '', '', ''], :style => [borders[:right], 0, 0, 0, 0, 0, 0, borders[:left]]
      end

      c += 1
      counter_row += 1
    end
    f_sheet.merge_cells("B" + counter_row.to_s + ":G" + counter_row.to_s)
    f_sheet.add_row ['', '', '', '', '', '', ''], :style => [0, borders[:top], borders[:top], borders[:top], borders[:top], borders[:top], borders[:top], borders[:top]]
    f_sheet.add_row []
    counter_row += 1

    # Header
    f_sheet.add_row ['', t('estimate_task'), t('estimate_hours_min'), t('estimate_hours_max'), t('estimate_rate'), t('estimate_cost_min'), t('estimate_cost_max')], :style => [nil, cs_header, cs_header, cs_header, cs_header, cs_header, cs_header]
    f_sheet.add_row [''], :style => [nil, cs_header, cs_header, cs_header, cs_header, cs_header, cs_header]
    counter_row += 2
    letts = ["B", "C", "D", "E", "F", "G"]
    letts.each do |letter|
      f_sheet.merge_cells(letter + counter_row.to_s + ":" + letter + (counter_row + 1).to_s)
    end

    # Sheets
    estimate_total_hours_min = 0
    estimate_total_hours_max = 0
    sheets.each do |sheet|

      f_sheet.add_row ['', sheet.title, '', '', '', '', ''], :style => [nil, cs_grey_dark, cs_grey_dark, cs_grey_dark, cs_grey_dark, cs_grey_dark, cs_grey_dark]

      # Sections
      sections = EstimatesSection.where(:estimates_sheet_id => sheet.id).order("id ASC")
      sections.each do |f_section|
        f_sheet.add_row ['', f_section.title, f_section.total_min_hours, f_section.total_max_hours, '', '', ''], :style => [nil, cs_grey, cs_grey, cs_grey, cs_grey, cs_grey, cs_grey]
        estimate_total_hours_min += f_section.total_min_hours
        estimate_total_hours_max += f_section.total_max_hours

        # Lines
        lines = EstimatesLine.where(:estimates_sections_id => f_section.id).order("line_number ASC")
        lines.each do |f_line|
          rate_per_hour = rate_prices.where(:technology_id => f_line.technology_id, :position_id => f_line.position_id).first.hourly_rate
          rate_ph = rate_per_hour.to_s + ' ' + currency_symbol
          price_min = (f_line.hours_min * rate_per_hour).to_s + ' ' + currency_symbol
          price_max = (f_line.hours_max * rate_per_hour).to_s + ' ' + currency_symbol
          f_sheet.add_row ['', f_line.line, f_line.hours_min, f_line.hours_max, rate_ph, price_min, price_max], :style => [nil, cs_normal, cs_normal, cs_normal, cs_normal, cs_normal, cs_normal]
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
