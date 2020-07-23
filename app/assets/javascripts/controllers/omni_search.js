$(document).on('load ajax:success', function() {


  $("#omni_search_button").click(function() {
    $("#loading_results").removeClass("hide");
    $("#omni_search_results").empty();

    $(this).val("Searching....");
    $(this).addClass("disabled");

  });

  $("#reset_omni_search").click(function(){
    $("#loading_results").addClass("hide");
    $("#omni_search_button").val("Search");
    $("#omni_search_button").removeClass("disabled");
  });


});
