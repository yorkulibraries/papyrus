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
		$(".attachment .attachment-actions").hide();
		$(".attachment .select-multiple").show();
		$(this).hide();
		$("a.cancel_delete_multiple").show();
		$("a.submit_delete_multiple").show();
		return false;
	})


	$("a.cancel_delete_multiple").click(function() {
		$(".attachment .attachment-actions").show();
		$(".attachment .select-multiple").hide();
		$(this).hide();
		$("a.delete_multiple").show();
		$("a.submit_delete_multiple").hide();
		return false;
	});

	$("a.submit_delete_multiple").click(function() {
		var result = confirm("Are you sure?");
		if (result) {
			$(this).closest('form').submit();
		} else {
			return false;
		}
	});


	$( ".datepicker" ).datepicker({ dateFormat: 'yy-mm-dd' });


});
