$ ->
  $(document).on 'change', '#rates_technologies_select', (evt) ->
    $.ajax 'rates_update_positions',
      type: 'GET'
      dataType: 'script'
      data: {
        technology_id: $("#rates_technologies_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic technology select OK!")