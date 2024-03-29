# frozen_string_literal: true

module ItemsHelper
  def display_icon(type)
    case type
    when Item::BOOK
      'book'
    when Item::ARTICLE
      'file-text-alt'
    when Item::COURSE_KIT
      'paperclip'
    else
      'flag'
    end
  end

  def format_field(field, what: 'n/a')
    if field.blank?
      content_tag(:span, what, class: 'not-filled-in')
    else
      field
    end
  end

  def isbn_for_image_cover(item)
    item.isbn.split(',').first.gsub(/[^0-9]+/, '')
  rescue StandardError
    ''
  end
end
