# frozen_string_literal: true

module CoursesHelper
  def short_course_code(code)
    if code
      chunks = code.split('_')
      "#{chunks[2]} #{chunks[4]}"
    else
      code
    end
  end
end
