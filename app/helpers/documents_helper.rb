module DocumentsHelper

  def edit_document_path(attachable, document)
    return "" if attachable == nil || document == nil

    path = case attachable.class.name
    when "Student"
      edit_student_document_path(attachable, document)
    when "Course"
      edit_course_document_path(attachable, document)
    else
      ""
    end

    return path
  end

end
