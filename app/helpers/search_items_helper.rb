module SearchItemsHelper
  
  def bib_search_label
    APP_CONFIG[:bib_search][:label]
  end
  
  def bib_search_type
    APP_CONFIG[:bib_search][:type]
  end
end
