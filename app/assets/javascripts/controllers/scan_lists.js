$(document).ready(function() {

  $(".scan_list_status label").click(function() {
    $(this).children("input[type=radio]").prop('checked',true);
    $(this).parents('form:first').submit();
  });
});
