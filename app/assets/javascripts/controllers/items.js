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
	
});