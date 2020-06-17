$(document).ready(function() {

  $("#search_primo_button").click(function() {
    $("#loading_results").removeClass("hide");
    $("#primo_results").empty();

    $(this).val("Searching....");
    $(this).addClass("disabled");

  });

  $("#reset_primo_search").click(function(){
    $("#loading_results").addClass("hide");
    $("#search_primo_button").val("Search");
    $("#search_primo_button").removeClass("disabled");
  });


});
