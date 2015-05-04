class EstimateImporterController < ApplicationController
  before_action :signed_in_user
  require 'roo'

  def new
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.estimates_importer_index'), new_estimate_importer_path
  end

  def import
    ActiveRecord::Base.transaction do
      proceed = 1

      # open file
      f = params[:imported_file]
      case File.extname(f.original_filename)
        when ".csv" then spreadsheet = Roo::Csv.new(f.path, nil, :ignore)
        when ".xls" then spreadsheet = Roo::Excel.new(f.path, nil, :ignore)
        when ".xlsx" then spreadsheet = Roo::Excelx.new(f.path, nil, :ignore)
        else proceed = 0
      end

      if proceed == 0
        add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
        add_breadcrumb I18n.t('breadcrumbs.estimates_importer_index'), new_estimate_importer_path
        flash[:error] = t('unknown_file_type') + " #{f.original_filename}"
        render 'new'
      else
        # General info
        sheet_general = spreadsheet.sheet(0)
        @info = {}
        @info[:client] = sheet_general.cell(1, 2)
        @info[:project] = sheet_general.cell(2, 2)

        # Assumptions
        assumptions = []
        row_counter = 6
        while true
          assmpt = sheet_general.cell(row_counter, 2)

          if (assmpt != 'Task' && assmpt != nil && assmpt != '')
            assumptions.push(assmpt)
            row_counter += 1
          else
            break
          end
        end
        @info[:assumptions] = assumptions

        # Estimation Sheets
        sheet_counter = 0;
        estimation_sheets = []
        spreadsheet.each_with_pagename do |name, sheet|
          if sheet_counter > 0

            sheet_data = {}
            sheet_data[:name] = name

            sections = []
            section_row_counter = 1
            while true
              if sheet.cell(section_row_counter, 1) != nil && sheet.cell(section_row_counter, 1) != ''
                section_single = {}
                section_single[:title] = sheet.cell(section_row_counter, 1)
                section_single[:lines] = []
                sections.push(section_single)
              end

              line = {}
              line[:line] = sheet.cell(section_row_counter, 2)
              line[:hours_min] = sheet.cell(section_row_counter, 3)
              line[:hours_max] = sheet.cell(section_row_counter, 4)

              section_single[:lines].push(line)

              section_row_counter += 1

              if sheet.cell(section_row_counter, 2) == nil || sheet.cell(section_row_counter, 2) == '' || section_row_counter == 100
                break
              end
            end

            sheet_data[:sections] = sections
            estimation_sheets.push(sheet_data)
            @info[:sheets] = estimation_sheets

          end
          sheet_counter += 1
        end

        # Database
        client_id = 0
        project_id = 0
        estimate_id = 0

        # Client
        if Client.exists?(:title => @info[:client])
          client_id = Client.find_by(:title => @info[:client]).id
        else
          client = Client.new()
          client.title = @info[:client]
          client.created_user_id = @current_user.id
          client.created_date = DateTime.now
          client.modified_user_id = @current_user.id
          client.modified_date = DateTime.now
          client.save
          client_id = client.id
        end
        @info[:client_id] = client_id

        # Project
        if Project.exists?(:title => @info[:project])
          project_id = Project.find_by(:title => @info[:project]).id
        else
          project = Project.new()
          project.title = @info[:project]
          project.client_id = client_id
          project.project_status_id = ProjectStatus.first.id
          project.account_manager_user_id = @current_user.id
          project.production_manager_user_id = @current_user.id
          project.project_owner_user_id = @current_user.id
          project.internal_yn = 0
          project.created_user_id = @current_user.id
          project.created_date = DateTime.now
          project.modified_user_id = @current_user.id
          project.modified_date = DateTime.now
          project.save
          project_id = project.id
        end
        @info[:project_id] = project_id

        # Estimate
        if Estimate.exists?(:title => @info[:project])
          estimate_id = Estimate.find_by(:title => @info[:project]).id
        else
          estimate = Estimate.new()
          estimate.title = @info[:project]
          estimate.client_id = client_id
          estimate.project_id = project_id
          estimate.owner_user_id = @current_user.id
          estimate.created_user_id = @current_user.id
          estimate.created_date = DateTime.now
          estimate.modified_user_id = @current_user.id
          estimate.modified_date = DateTime.now
          estimate.rate_id = Rate.first.id
          estimate.engagement_model_id = EngagementModel.first.id
          estimate.save
          estimate_id = estimate.id
        end
        @info[:estimate_id] = estimate_id

        # Assumptions
        @info[:assumptions].each do |title|
          unless EstimatesAssumption.exists?(:estimate_id => estimate_id, :title => title)
            estimate_assumption = EstimatesAssumption.new()
            estimate_assumption.estimate_id = estimate_id
            estimate_assumption.title = title
            estimate_assumption.save
          end
        end

        @info[:qqqqqq] = []

        # Sheet
        @info[:sheets].each do |sheet|
          sheet_id = 0
          if EstimatesSheet.exists?(:title => sheet[:name], :estimate_id => estimate_id)
            sheet_id = EstimatesSheet.find_by(:title => sheet[:name], :estimate_id => estimate_id).id
          else
            esheet = EstimatesSheet.new()
            esheet.estimate_id = estimate_id
            esheet.title = sheet[:name]
            esheet.save
            sheet_id = esheet.id
          end

          # Sheet - Section
          sheet[:sections].each do |section|
            section_id = 0
            if EstimatesSection.exists?(:title => section[:title], :estimates_sheet_id => sheet_id, :estimate_id => estimate_id)
              section_id = EstimatesSection.find_by(:title => section[:title], :estimates_sheet_id => sheet_id, :estimate_id => estimate_id).id
            else
              esection = EstimatesSection.new()
              esection.estimate_id = estimate_id
              esection.estimates_sheet_id = sheet_id
              esection.title = section[:title]
              esection.save
              section_id = esection.id
            end

            # Sheet - Section - Line
            eline_counter = 1;
            eindex = 0
            section[:lines].each do |line|
              unless EstimatesLine.exists?(:estimate_id => estimate_id, :estimates_sections_id => section_id, :line => section[:lines][eindex][:line])
                eline = EstimatesLine.new()
                eline.estimate_id = estimate_id
                eline.estimates_sections_id = section_id
                eline.technology_id = Technology.first.id
                eline.line_number = eline_counter
                eline.line = section[:lines][eindex][:line]
                eline.complexity = 1
                eline.hours_min = section[:lines][eindex][:hours_min]
                eline.hours_max = section[:lines][eindex][:hours_max]
                eline.created_user_id = current_user.id
                eline.created_date = DateTime.now
                eline.position_id = Position.first.id
                eline.save
                eline_counter += 1
                eindex += 1
              end
            end

          end

        end

        add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
        add_breadcrumb I18n.t('breadcrumbs.estimates_importer_index'), new_estimate_importer_path
        flash[:success] = t('import_ok')
        render 'new'
      end
    end
  end
end
