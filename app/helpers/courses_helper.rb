module CoursesHelper

  def short_name(code)
    if code
      chunks = code.split("_")
      return "#{chunks[2]} #{chunks[4]}"
    else
      return code
    end
  end
end
