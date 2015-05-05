$ ->
  $(document).on 'change', '[id^=users_technologies_select_]', (evt) ->
    $.ajax 'users/users_update_positions',
      type: 'GET'
      dataType: 'script'
      data: {
        technology_id: $("option:selected", this).val(),
        item_id: this.id.replace('users_technologies_select_', '')
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic technology select OK!")