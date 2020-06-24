$(document).ready(function() {

  $(".todo_list_status, .todo_item_status").click(function() {    
    $(this).parents('form:first').submit();
  });


});
