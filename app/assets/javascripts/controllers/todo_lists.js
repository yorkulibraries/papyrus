$(document).ready(function() {

  $(".todo_list_status, .todo_item_status").click(function() {
    console.log("SUBMITTING")
    $(this).parents('form:first').submit();

  });


});
