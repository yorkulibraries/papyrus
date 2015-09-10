module SearchItemsHelper

  def bib_search_vufind_label
    PapyrusSettings.vufind_label
  end
  def bib_search_worldcat_label
    PapyrusSettings.worldcat_label
  end


  def format_vufind_field(field, field_name = nil)

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
  alias :format_worldcat_field :format_vufind_field

  def encode_field(field)
    if field.encoding.name != "UTF-8"
      #field.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '?')
      #field.force_encoding("UTF-8")
      field # for now do nothing
    else
      field
    end
  end

end
