module DocumentsHelper

  def edit_document_path(attachable, document)
    return "" if attachable == nil || document == nil

    path = case attachable.class.name
    when "Student"
      edit_student_document_path(attachable, document)
    when "Course"
      edit_term_course_document_path(@term, attachable, document)
    else
      ""
    end

    return path
  end

  def new_document_path(attachable)
    return "" if attachable == nil

    path = case attachable.class.name
    when "Student"
      new_student_document_path(attachable)
    when "Course"
      new_course_document_path(attachable)
    else
      ""
    end

    return path
  end



end
