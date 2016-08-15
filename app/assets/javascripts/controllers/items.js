function guidGenerator(small) {
    var S4 = function() {
       return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
    };

	if (undefined_helper(small) == "")
    	return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
	else
		return (S4()+S4());
}


$(document).ready(function() {
	$("tr.item td.icon").click(function() {
		var id = $(this).data("id");
		$("tr#item_extra_" + id).toggle();
	});


	$("a.delete_multiple").click(function() {
		$(".attachment .actions").hide();
		$(".attachment .select-multiple").removeClass("hide");
		$(this).hide();
		$("a.cancel_delete_multiple, a.submit_delete_multiple").removeClass("hide");
		$("").show();
		return false;
	})


	$("a.cancel_delete_multiple").click(function() {
		$(".attachment .actions").show();
		$(".attachment .select-multiple").addClass("hide");

		$("a.delete_multiple").show();
		$("a.submit_delete_multiple, a.cancel_delete_multiple").addClass("hide");
		return false;
	});

	$("a.submit_delete_multiple").click(function() {
		var result = confirm("Are you sure?");
		if (result) {
			$("#delete_multiple_form").submit();
		}
    return false;
	});


	$( ".datepicker" ).datepicker({ dateFormat: 'yy-mm-dd' });


  $("input[name=create_acquisition_request]").on("click load", function() {
    if (this.checked) {
      $("#create_acquisition_request").removeClass("hide");
    } else {
      $("#create_acquisition_request").addClass("hide");
    }

  });


  $("#show_expired_items_list").click(function(){
    $("#items").hide();
    $("#expired_items").removeClass("hide");
    $("#show_current_items_list").removeClass("hide");
    $(this).addClass("hide");
    return false;
  });

});

function setup_item_token_input(id, url, token_limit) {
  $(id).tokenInput(url, {
    tokenLimit: token_limit,
    hintText: "Type the title of your item to search",
    zindex: 9999999,
    allowTabOut: true,
    onReady: function() {      
      $("#token-input-" + id).attr("tabindex", "1");
    },
    resultsFormatter: function(item) {
      var line1 = "<div class='item-token-view results-view'>" + item.name + "<br/>";
      var line2 = "<span class='meta'>" + safe(item.author) + " | " + safe(item.isbn) +  " | " + safe(item.callnumber) + "</span></div>";

      return "<li>" +  line1 + line2 + "</li>";
    },
    tokenFormatter: function(item) {
      var line1 = "<div class='item-token-view'>" + item.name + "<br/>";
      var line2 = "<span class='meta'>" + safe(item.author) + " | " + safe(item.isbn) +  " | " + safe(item.callnumber) + "</span></div>";
      return "<li>" +  line1 + line2 + "</li>";
    }
  });
}
