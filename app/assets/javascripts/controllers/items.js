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


});
