$(document).ready(function() {
	var url = "http://books.google.com/books?jscmd=viewapi&bibkeys="
	$("img.google-bookcover").each(function(){
		var isbn = $(this).data("isbn");						
		url = url + isbn + ",";
		

	});
	url = url + "&callback=setup_google_book_covers";
	
	if ($("img.google-bookcover").size() > 0) {
	  var head = document.getElementsByTagName('head').item(0);
	  var script = document.createElement('script');
	  script.setAttribute('type', 'text/javascript');
	  script.setAttribute('src', url);
	  head.appendChild(script);			
	}
	
});

function setup_google_book_covers(details) {
	$("img.google-bookcover").each(function(){
		var isbn = $(this).data("isbn");			
		var size = $(this).data("size")
		
		if (details[isbn] && details[isbn].thumbnail_url) {

			if (size == "large"){
				$(this).attr("src",details[isbn]["thumbnail_url"].replace("zoom=5", "zoom=1") );
			} else {
				$(this).attr("src",details[isbn]["thumbnail_url"] );
			}
		}
	});
}