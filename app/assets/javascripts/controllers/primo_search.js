$(document).ready(function() {

  $("#search_primo_button").click(function() {
    $("#loading_results").removeClass("hide");
    $(this).prop('disabled', true);
    $("#primo_results").empty();
  });

  $("#reset_primo_search").click(function(){
    $("#loading_results").addClass("hide");
    $(this).prop('disabled', false);
  });
});
