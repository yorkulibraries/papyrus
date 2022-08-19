module DocumentsHelper
  def edit_document_path(attachable, document)
    return '' if attachable.nil? || document.nil?

    case attachable.class.name
    when 'Student'
      edit_student_document_path(attachable, document)
    when 'Course'
      edit_course_document_path(attachable, document)
    else
      ''
    end
  end

  def new_document_path(attachable)
    return '' if attachable.nil?

    case attachable.class.name
    when 'Student'
      new_student_document_path(attachable)
    when 'Course'
      new_course_document_path(attachable)
    else
      ''
    end
  end
end
