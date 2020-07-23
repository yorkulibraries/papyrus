module Items::FromWorldcatHelper

  def format_worldcat_field(field, field_name = nil)

    if field.blank?
       if field_name == nil
         content_tag(:span, "Not provided...", class: "weak")
       else
         content_tag(:span, "#{field_name} not provided...", class: "weak")
       end
    else
      if field.kind_of?(Array)
        field.reject { |i| i.blank? }.join(", ")
      else
        field = encode_field(field) rescue "Error Encoding: #{Encoding.default_external}"
      end


    end

  end
end
