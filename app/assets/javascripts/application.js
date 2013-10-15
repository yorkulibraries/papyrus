//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_self
//= require_tree .

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
	$("input[placeholder], textarea[placeholder]").enablePlaceholder({"withPlaceholderClass": "light-text"});	
	
	$('.dropdown-toggle').dropdown();
	
	// disable in browser form validations
	$('form').find('input').removeAttr('required');
	
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

function guidGenerator(small) {
    var S4 = function() {
       return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
    };

	if (undefined_helper(small) == "") 
    	return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());	
	else
		return (S4()+S4());
}
