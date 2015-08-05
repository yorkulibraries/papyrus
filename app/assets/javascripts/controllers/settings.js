function deletable(e) {
	if(e.keyCode == 8 && e.shiftKey && $(this).val() == "") {
		$(this).remove();
	}
}

$(document).ready(function() {

  $("a.add-array-field").click(function() {
		var c = $(this).data("class");
		var n = $(this).data("name");
		var t = $(this).data("type");
		var i = $("<input/>", { name: n, type: t, class: c, value: "" } ).keyup(deletable);
		$(i).insertBefore(this);

	});


  $(".deletable").keyup(deletable);
});
