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
//= require js-routes
//= require turbolinks
//= require bootstrap-sprockets
//= require filterrific/filterrific-jquery
//= require jquery.remotipart
//= require bootstrap-tokenfield
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
  $('[id^=ac_estimate_line_]').bind('railsAutocomplete.select', function(event, ui) {
    var elid = this.id.replace('ac_estimate_line_', '');
    $("#estimate_line_technology_id_" + elid).val(ui.item.technology);
    $("#estimate_line_hours_min_" + elid).val(ui.item.hours_min);
    $("#estimate_line_hours_max_" + elid).val(ui.item.hours_max);
  });
});