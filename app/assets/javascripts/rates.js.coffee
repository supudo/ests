$ ->
  $(document).on 'change', '#technologies_select', (evt) ->
    $.ajax 'update_positions',
      type: 'GET'
      dataType: 'script'
      data: {
        technology_id: $("#technologies_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic technology select OK!")