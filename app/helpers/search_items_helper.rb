module SearchItemsHelper
  def bib_search_vufind_label
    PapyrusSettings.vufind_label
  end

  def bib_search_worldcat_label
    PapyrusSettings.worldcat_label
  end

  def format_vufind_field(field, field_name = nil)
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

  def encode_field(field)
    if field.encoding.name != 'UTF-8'
      # field.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '?')
      # field.force_encoding("UTF-8")
      field # for now do nothing
    else
      field
    end
  end
end
