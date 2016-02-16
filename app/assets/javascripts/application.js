//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require twitter/bootstrap
//= require_tree ./vendor/
//= require_tree ./controllers/
//= require ./vendor/formstone.core.js
//= require ./vendor/formstone.upload.js
//= require_self

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
	$("input[placeholder], textarea[placeholder]").enablePlaceholder({"withPlaceholderClass": "light-text"});

	$('.dropdown-toggle').dropdown();

	// disable in browser form validations
	$('form').find('input').removeAttr('required');

	$("a[data-toggle=visibility]").click(function() {
		var id = $(this).attr("href");
		$(id).toggle();
		return false;
	});

	$("a[data-toggle-visible]").click(function(){
		var toggle = $(this).data("toggle-visible");
		$(toggle).toggleClass("hide");return false;
	});



	$('.submittable').click(function() {
		$(this).parents('form:first').submit();
	});




});


/** Requires a CSS element that has three data properties set: source, value-key and label-key **/
function autocomplete_search(element) {
  var source = $(element).data("source");
  var value_key = $(element).data("value-key");
  var label_key  = $(element).data("label-key");

  console.log("HERE + " + source);
  $(element).autocomplete({
    source: source,
    delay: 300,
    minLength: 1,
    create: function( event, ui ) { console.log("CREATED"); },
    search: function( event, ui ) { console.log("SEARCHING"); }


  });

  console.log("SETUP");
}



/**  HELPER TO DISPLAY UNDEFINED VALUES PROPERLY ***/
function safe(variable) { return undefined_helper(variable);}
function undefined_helper(variable) {
	if (variable == undefined)
		return "";
	else
		return variable;
}
