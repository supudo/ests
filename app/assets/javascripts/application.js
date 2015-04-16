// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require js-routes
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

var QueryString = function () {
  var query_string = {};
  var query = window.location.search.substring(1);
  var vars = query.split("&");
  for (var i=0;i<vars.length;i++) {
    var pair = vars[i].split("=");
    if (typeof query_string[pair[0]] === "undefined")
      query_string[pair[0]] = pair[1];
    else if (typeof query_string[pair[0]] === "string") {
      var arr = [ query_string[pair[0]], pair[1] ];
      query_string[pair[0]] = arr;
    }
    else
      query_string[pair[0]].push(pair[1]);
  } 
  return query_string;
} ();

$(document).ready(function() {
  $('#ac_search_client_').bind('railsAutocomplete.select', function(event, ui) {
    location.href = EstsRoutes.clients_path() + '/' + ui.item.id + '?locale=' + QueryString.locale;
  });

  $('#ac_search_project_').bind('railsAutocomplete.select', function(event, ui) {
    location.href = EstsRoutes.projects_path() + '/' + ui.item.id + '?locale=' + QueryString.locale;
  });

  $('#ac_search_user_').bind('railsAutocomplete.select', function(event, ui) {
    location.href = EstsRoutes.users_path() + '/' + ui.item.id + '?locale=' + QueryString.locale;
  });

  $('#ac_search_estimate_').bind('railsAutocomplete.select', function(event, ui) {
    location.href = EstsRoutes.estimates_path() + '/' + ui.item.id + '?locale=' + QueryString.locale;
  });
});
