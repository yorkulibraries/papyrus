$(document).ready(function() {
    $(".audit_event .audit_comment").click(function() {
      $(this).children("small").toggleClass("hide");
    });
});
