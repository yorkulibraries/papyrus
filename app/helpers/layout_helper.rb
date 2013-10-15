# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end
  
  def title_html(&block)
    content_for(:title_html) do
      yield block
    end
  end
  
  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  
  def splash_section(&block)
     content_for (:splash_section) do 
         yield block
     end 
  end
  
  
  def sidebar(&block)
     content_for (:sidebar) do 
         yield block
     end 
  end
end
