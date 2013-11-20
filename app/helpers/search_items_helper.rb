module SearchItemsHelper
  
  def bib_search_label
    PapyrusConfig.bib_search.label
  end
  
  def bib_search_type
    PapyrusConfig.bib_search.type
  end
  
  def format_solr_field(field, field_name = nil)
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
        field
      end
    end
    
  end
end
