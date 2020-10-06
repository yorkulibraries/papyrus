$(document).ready(function() {

  $("#search_worldcat_button").click(function() {
    $("#loading_results").removeClass("d-none");
    $("#worldcat_results").empty();

    $(this).val("Searching....");
    $(this).addClass("disabled");

  });

  $("#reset_worldcat_search").click(function(){
    $("#loading_results").addClass("d-none")
    $("#search_worldcat_button").val("Search");
    $("#search_worldcat_button").removeClass("disabled");
  });


});
