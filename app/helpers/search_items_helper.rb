module SearchItemsHelper
  
  def bib_search_label
    PapyrusConfig.bib_search.label
  end
  
  def bib_search_type
    PapyrusConfig.bib_search.type
  end
end
