module Items::FromWorldcatHelper
  def format_worldcat_field(field, field_name = nil)
    if field.blank?
      if field_name.nil?
        content_tag(:span, 'Not provided...', class: 'weak')
      else
        content_tag(:span, "#{field_name} not provided...", class: 'weak')
      end
    elsif field.is_a?(Array)
      field.reject { |i| i.blank? }.join(', ')
    else
      field = begin
        encode_field(field)
      rescue StandardError
        "Error Encoding: #{Encoding.default_external}"
      end

    end
  end
end
