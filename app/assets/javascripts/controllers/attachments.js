$(document).ready(function() {
	// jQuery FileUpload Setup
	$("#new_attachment").fileupload({
		dataType: "script",
		add: function(e, data) {
			data.context = $('<button/>').text('Upload')
							 .appendTo(document.body)
							 .click(function () {
									 data.context = $('<p/>').text('Uploading...').replaceAll($(this));
									 data.submit();
							 });
		},
		progress: function(e,data) {
			progress = parseInt(data.loaded / data.total * 100, 10);
			$("#progress .bar").css("width", progress + "%");
		}
	});

});
