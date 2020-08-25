var $filequeue;

$(document).ready(function() {

	load_formstone_upload_plugin();

});

/** LOAD Formstone Plugin function **/
function load_formstone_upload_plugin(){
	$filequeue = $(".formstone_upload_queue ol");
	$(".formstone_upload").upload({
			action: $(".formstone_upload").data("url"),
			label: $(".formstone_upload").data("label"),
			maxSize: 100000000000000000,
			postKey: "attachment[file]",
			postData: { multiple: true }
	}).on("start.upload", onStart)
			.on("complete.upload", onComplete)
			.on("filestart.upload", onFileStart)
			.on("fileprogress.upload", onFileProgress)
			.on("filecomplete.upload", onFileComplete)
			.on("fileerror.upload", onFileError);
}

/*** FORMSTONE UPLOAD EVENT HANDLES **/
function onStart(e,  files) {
	var html = '';
	for (var i = 0; i < files.length; i++) {
		html += '<li data-index="' + files[i].index + '"><span class="file">' + files[i].name + '</span><span class="progress">Queued</span></li>';
	}
	 $(".formstone_upload_queue").removeClass('d-none');
	 $("#uploaded_attachments").removeClass("d-none");

	$filequeue.append(html);

}

function onComplete(e) {
	$(".formstone_upload_queue").fadeOut(5000,function() { 	$filequeue.empty();  });
}

function onFileStart(e, file) {
	$filequeue.find("li[data-index=" + file.index + "]")
				.find(".progress").text("0%");
}

function onFileProgress(e, file, percent) {
		console.log("File Progress");
		$filequeue.find("li[data-index=" + file.index + "]")
				  .find(".progress").text(percent + "%");
}

function onFileComplete(e, file, response) {
	console.log("File Complete");
	if (response.trim() === "" || response.toLowerCase().indexOf("error") > -1) {
		$filequeue.find("li[data-index=" + file.index + "]").addClass("error")
				  .find(".progress").text(response.trim());
	} else {
		var $target = $filequeue.find("li[data-index=" + file.index + "]");
		$target.find(".file").text(file.name);
		$target.find(".progress").text("").append("<i class='icon-check'></i>");
	}
}

function onFileError(error) { console.log("File Error: " + error) ;}
