$ ->
$(document).ready ->
  $('#up_selectall').click (event) ->
    if @checked
      $('[name^=permission_ids]').each ->
        @checked = true
        return
    else
      $('[name^=permission_ids]').each ->
        @checked = false
        return
    return
  return