$ ->
  $(document).on 'change', '[id^=lines_technologies_select_]', (evt) ->
    $.ajax '/estimatesline/lines_update_positions',
      type: 'GET'
      dataType: 'script'
      data: {
        technology_id: $("option:selected", this).val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic technology select OK!")