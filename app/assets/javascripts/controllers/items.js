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
		$(".attachment .actions").addClass("d-none");
		$(".attachment .select-multiple").removeClass("d-none");
		$(this).addClass("d-none");
		$("a.cancel_delete_multiple, a.submit_delete_multiple").removeClass("d-none");
		$("").removeClass('d-none');
		return false;
	})


	$("a.cancel_delete_multiple").click(function() {
		$(".attachment .actions").removeClass('d-none');
		$(".attachment .select-multiple").addClass("d-none")

		$("a.delete_multiple").removeClass('d-none');
		$("a.submit_delete_multiple, a.cancel_delete_multiple").addClass("d-none")
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
      $("#create_acquisition_request").removeClass("d-none");
    } else {
      $("#create_acquisition_request").addClass("d-none")
    }

  });


  $("#show_expired_items_list").click(function(){
    $("#items").addClass("d-none");
    $("#expired_items").removeClass("d-none");
    $("#show_current_items_list").removeClass("d-none");
    $(this).addClass("d-none")
    return false;
  });

});

var tokenInputInstance;
function setup_item_token_input(id, url, token_limit) {
  if (!tokenInputInstance) {
    tokenInputInstance = $(id).tokenInput(url, {
      tokenLimit: token_limit,
      hintText: "Type the title of your item to search",
      zindex: 9999999,
      allowTabOut: true,
      onReady: function () {
        $("#token-input-" + id).attr("tabindex", "1");
      },
      resultsFormatter: function (item) {
        var line1 = "<div class='item-token-view results-view'>" + item.name + "<br/>";
        var line2 =
          "<span class='meta'>" + safe(item.author) + " | " + safe(item.isbn) + " | " + safe(item.callnumber) + "</span>";
        var line3 = "</div>";
        if (item.item_type == "course_kit") {
          line2 = "<span class='meta'>" + safe(item.course_code) + "</span>";
        }

        return "<li>" + line1 + line2 + line3 + "</li>";
      },
      tokenFormatter: function (item) {
        var line1 = "<div class='item-token-view'>" + item.name + "<br/>";
        var line2 =
          "<span class='meta'>" + safe(item.author) + " | " + safe(item.isbn) + " | " + safe(item.callnumber) + "</span>";
        var line3 = "</div>";
        if (item.item_type == "course_kit") {
          line2 = "<span class='meta'>" + safe(item.course_code) + "</span>";
        }
        return "<li>" + line1 + line2 + line3 + "</li>";
      },
    });
  }
}
