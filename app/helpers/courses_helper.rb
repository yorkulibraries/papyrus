module CoursesHelper

  def short_course_code(code)
    if code
      chunks = code.split("_")
      return "#{chunks[2]} #{chunks[4]}"
    else
      return code
    end
  end
end
