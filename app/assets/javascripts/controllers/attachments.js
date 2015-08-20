$(document).ready(function() {
	// jQuery FileUpload Setup
	$("#new_multiple_attachments").fileupload({
		dataType: "script",
		add: function (e, data) {

				button = $('#add_attachment_button')
							.click(function () {
							console.log("Uploading here");
							jqXHR = data.submit();
							//$(this).hide();
							//$(this).parent().remove();
							return false;
						});

				cancel_button = $('#cancel_upload_button')
							.click(function () {
								console.log("cancel_button");
								});



				$.each(data.files, function (index, file) {
					console.log(file)	;
				});

	    },
	    start: function (e) {
				$('#progress').show();
	    },

	    progress: function (e, data) {
				$.each(data.files, function (index, file) {
					var rate = (data.loaded / data.total) * 100
					$("#progress .bar").css({'font-size': '18px','width': rate + '%'}).text(Math.round(rate) + "% of " + (data.total/1000) + " KBytes ").show();

	       });
	    },
	    done: function (e, data) {
	      $.each(data.files, function (index, file) {
					$('#progress').hide();
	      });
				this.reset();

	    },
	    fail: function (e, data) {
			$('#upload_error').show();
	        $.each(data.files, function (index, file) {
	            $('#upload_error').text("There was an error uploading " + file.name + " file. Thrown: " + data.errorThrown + "Status: " + data.textStatus).show();
	        });
	    }
	});

});
