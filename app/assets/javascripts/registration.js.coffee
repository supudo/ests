$ ->
  $(document).on 'change', '#registration_technologies_select', (evt) ->
    $.ajax 'registration/registration_update_positions',
      type: 'GET'
      dataType: 'script'
      data: {
        technology_id: $("option:selected", this).val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic technology select OK!")