function setup_course_token_input(id, url, token_limit) {
  $(id).tokenInput(url, {
    tokenLimit: token_limit,
    hintText: "Type the course name to search",
    zindex: 9999999,
    resultsFormatter: function(course) {
      var line1 = "<div class='course-token-view results-view'>" + course.name;
      var line2 = "<span class='meta'>" + safe(course.term) + "</span></div>";

      return "<li>" +  line1 + line2 + "</li>";
    },
    tokenFormatter: function(course) {
      var line1 = "<div class='course-token-view'>" + course.name ;
      var line2 = "<span class='meta'>" + safe(course.term) + "</span></div>";
      return "<li>" +  line1 + line2 + "</li>";
    }
  });
}
