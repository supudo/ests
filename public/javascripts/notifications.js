function showNotification(notif_element, notif_type, notif_message) {
  if (notif_element == null)
    notif_element = 'bottom-left';

  var notif_delay = 3000;
  if (notif_type == 'success')
    notif_delay = 3000;
  else if (notif_type == 'warning')
    notif_delay = 4000;
  else if (notif_type == 'danger')
    notif_delay = 5000;
  else if (notif_type == 'blackgloss')
    notif_delay = 6000;
  else
    notif_delay = 3000;

  $('.' + notif_element).notify({
    message: { text: ' ' + notif_message + ' ' },
    type: notif_type,
    fadeOut: {
      delay: Math.floor(Math.random() * 500) + 2500
    }
  }).show();
}
