module UtilsHelper
  def pp(object)
    (ap object).html_safe
  rescue StandardError
  end

  def blank_slate(list = nil, title: 'No items found', description: 'Click on new button to add new item.', icon: nil)
    if list.nil? || list.size == 0
      fa = icon.nil? ? '' : content_tag(:i, '', class: "fas fa-#{icon} fa-3x")
      h4 = content_tag(:h4, title.html_safe, class: 'mt-4')
      p = content_tag(:p, description.html_safe)
      content_tag(:div, fa.html_safe + h4 + p, class: 'blank-slate')
    end
  end

  def audit_type_path(audit)
    type = audit.auditable_type
    id = audit.auditable_id
    associated_id = audit.associated_id
    associated_type = audit.associated_type

    begin
      case type.tableize.singularize

      when 'access_code'
        if associated_id
          student_path(associated_id)
        else
          shared_access_codes_path
        end
      when 'announcement'
        announcements_path
      when 'attachment'
        item_path(associated_id)
      when 'document'
        if associated_type == 'Course'
          course_path(associated_id)
        else
          student_path(associated_id)
        end
      when 'todo_item'
        todo_list_path(associated_id)
      when 'todo_list'
        todo_list_path(id)
      when 'item_connection'
        student_path(associated_id)
      when 'item_course_connection'
        item_path(associated_id)
      when 'item'
        item_path(id)
      when 'acquisition_request'
        acquisition_request(id)
      when 'note'
      when 'student'
        student_path(associated_id)
      when 'student_details'
        student_path(associated_id)
      when 'user'
        user_path(id)
      when 'course'
        course_path(id)
      when 'term'
        term_path(id)
      else
        root_path
      end
    rescue StandardError
      root_path
    end
  end
end
