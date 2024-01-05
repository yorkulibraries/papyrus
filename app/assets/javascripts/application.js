//= require jquery3
//= require popper
//= require bootstrap
//= require best_in_place
//= require rails-ujs
//= require jquery.remotipart
//= require jquery-ui
//= require best_in_place.jquery-ui
//= require_tree ./vendor/
//= require_tree ./controllers/
//= require ./vendor/formstone.core.js
//= require ./vendor/formstone.upload.js
//= require ./vendor/bootbox.min.js
//= require moment
//= require fullcalendar
//= require_self

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function () {
	$('#calendar').fullCalendar();

	$("input[placeholder], textarea[placeholder]").enablePlaceholder({ "withPlaceholderClass": "light-text" });

	//$('.dropdown-toggle').dropdown();

	// disable in browser form validations
	$('form').find('input').removeAttr('required');

	$("a[data-toggle=visibility]").click(function () {
		var id = $(this).attr("href");
		$(id).toggle();
		return false;
	});

	$("a[data-toggle-visible]").click(function () {
		var toggle = $(this).data("toggle-visible");
		$(toggle).toggleClass("d-none"); return false;
	});

	$(".datepicker").datepicker({ dateFormat: 'yy-mm-dd' });
	$.datepicker.setDefaults({ dateFormat: 'yy-mm-dd' });

	$('.submittable').click(function () {
		$(this).parents('form:first').submit();
	});

	// Best In Place - In Place Editting
	$(".best_in_place").best_in_place();
	$(".best_in_place").attr("title", "Click to edit");

});


/** Requires a CSS element that has three data properties set: source, value-key and label-key **/
function autocomplete_search(element) {
	var source = $(element).data("source");
	var value_key = $(element).data("valuekey");
	var label_key = $(element).data("labelkey");
	var value_input_name = $(element).data("valueinput");

	$(element).autocomplete({
		source: source,
		delay: 300,
		minLength: 1,
		create: function (event, ui) { console.log("CREATED"); },
		search: function (event, ui) { console.log("SEARCHING"); },
		response: function (event, ui) {
			var new_content = [];

			for (var i = 0; i = ui.content.length; i++) {
				var row = ui.content.pop();
				new_content.push(row);
			}

			for (var i = 0; i = new_content.length; i++) {
				var row = new_content.pop();
				ui.content.push({ label: row[label_key], value: row[value_key] });
			}

		},
		select: function (event, ui) {
			$(value_input_name).val(ui.item.value);
			console.log(ui.item.label);
			$(element).val(ui.item.label);
			return false;
		}

	}).autocomplete("instance")._renderItem = function (ul, item) {
		return $("<li>").append(item.label).appendTo(ul);
	};

	console.log("SETUP");
}



/**  HELPER TO DISPLAY UNDEFINED VALUES PROPERLY ***/
function safe(variable) { return undefined_helper(variable); }
function undefined_helper(variable) {
	if (variable == undefined)
		return "";
	else
		return variable;
}
