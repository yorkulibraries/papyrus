//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery-migrate-1.0.0
//= require jquery-fileupload/basic-plus
//= require jquery-fileupload/jquery.fileupload-ui
//= require jquery-fileupload/vendor/tmpl
//= require twitter/bootstrap
//= require_self
//= require_tree ./vendor/
//= require_tree ./controllers/
//= require ./vendor/formstone.core.js
//= require ./vendor/formstone.upload.js

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



	$('.submittable').click(function() {
		$(this).parents('form:first').submit();
	});




});


function bind_autocomplete_search(element, url, resultFunction, formatFunction) {

	$(element).autocomplete(url, {
			width: 500,
			dataType: "json",
			multiple: true,
		    delay: 200,
			highlight: false,
			matchSubset: false,
			parse: function(data) {
						return $.map(data, function(row) {
							return {
								data: row
							}
						});
					},

			max: 20,
			formatItem: formatFunction
		});

	// Result for top search
	$(element).result(resultFunction);
}

/**  HELPER TO DISPLAY UNDEFINED VALUES PROPERLY ***/
function safe(variable) { return undefined_helper(variable);}
function undefined_helper(variable) {
	if (variable == undefined)
		return "";
	else
		return variable;
}
