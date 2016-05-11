module UtilsHelper

  def blank_slate(list = nil, title: "No items found", description: "Click on new button to add new item.", icon: nil)
    if list == nil || list.size == 0
      fa = icon == nil ? "" : content_tag(:i, "", class: "fa fa-#{icon}")
      h4 = content_tag(:h4, title.html_safe)
      p = content_tag(:p, description.html_safe)
      content_tag(:div, fa.html_safe + h4 + p, class: "blank-slate")
    end
  end
end
