# frozen_string_literal: true

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
      field.reject(&:blank?).join(', ')
    else
      field = begin
        encode_field(field)
      rescue StandardError
        "Error Encoding: #{Encoding.default_external}"
      end

    end
  end

  def encode_field(field)
    field
  end
end
