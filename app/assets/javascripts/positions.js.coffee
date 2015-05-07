$ ->
  $(document).on 'change', '[id^=positions_technologies_select_]', (evt) ->
    $.ajax '/positions/positions_update_complexity',
      type: 'GET'
      dataType: 'script'
      data: {
        technology_id: $("option:selected", this).val(),
        item_id: this.id.replace('positions_technologies_select_', '')
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic technology select OK!")