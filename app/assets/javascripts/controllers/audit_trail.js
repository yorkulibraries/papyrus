$(document).ready(function() {
    $(".audit_event .audit_comment").click(function() {
      $(this).children("div.details").toggleClass("d-none");
    });
});
