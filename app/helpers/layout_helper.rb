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
    content_for(:splash_section) do
      yield block
    end
  end

  def sidebar(&block)
    content_for(:sidebar) do
      yield block
    end
  end

  def panel(title: 'untitled', title_class: 'bg-primary text-white', icon: 'th', icon_class: '', styles: '', &block)
    icon_tag = content_tag(:i, '', class: "fas fa-#{icon} #{icon_class}")
    title_tag = content_tag(:strong, icon_tag + " #{title}")

    heading_div = content_tag(:h6, title_tag, class: "card-title mb-0 p-3 rounded-top #{title_class}")
    body_div = content_tag :div, class: 'card-body' do
      yield block
    end

    content_tag :div, heading_div + body_div, class: "card shadow-sm mb-3 #{styles}"
  end

  def field_format(field, simple_format = false)
    # If field is blank, print out blank message
    if field.blank?
      content_tag(:span, 'Not filled in...', class: 'empty-field')
    elsif field.is_a? Date
      field.strftime('%B %d, %Y')
    else
      simple_format ? simple_format(field) : field
    end
  end

  ## WRAPPER FOR BEST_IN_PLACE WITH SOME DEFAULTS
  def in_place_edit(object, field, *args)
    ok = "\u2713"
    cancel = "\u2A09"
    defaults = {
      place_holder: 'Click me to add content!',
      inner_class: 'field',
      ok_button: ok, ok_button_class: 'btn btn-link green',
      cancel_button: cancel,
      cancel_button_class: 'btn btn-link red'
    }

    options = args.extract_options!
    defaults.merge!(options)

    best_in_place object, field, defaults
  end
end
