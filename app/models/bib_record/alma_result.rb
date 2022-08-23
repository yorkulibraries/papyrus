# frozen_string_literal: true

require 'alma'
class BibRecord::AlmaResult
  def self.find_item(id)
    configure
    items = Alma::BibItem.find(id)
    items.first
  end

  def self.build_item_from_alma_result(alma_record)
    return Item.new if alma_record.nil? || alma_record['bib_data'].nil?

    id = begin
      get_value alma_record['bib_data']['mms_id']
    rescue StandardError
      ''
    end
    item = Item.new
    item.item_type = Item::BOOK
    item.title = begin
      get_value alma_record['bib_data']['title']
    rescue StandardError
      'n/a'
    end
    item.unique_id = "alma_#{id}"
    item.author = begin
      get_value alma_record['bib_data']['author']
    rescue StandardError
      'n/a'
    end
    item.isbn = begin
      get_value alma_record['bib_data']['isbn']
    rescue StandardError
      'n/a'
    end
    publisher1 = begin
      get_value alma_record['bib_data']['place_of_publication']
    rescue StandardError
      'n/a'
    end
    publisher2 = begin
      get_value(alma_record['bib_data']['publisher_const'])
    rescue StandardError
      ''
    end

    item.publisher = "#{publisher1} #{publisher2}"
    item.published_date = begin
      get_value alma_record['bib_data']['date_of_publication']
    rescue StandardError
      'n/a'
    end
    item.edition = begin
      get_value alma_record['bib_data']['complete_edition']
    rescue StandardError
      'n/a'
    end
    item.callnumber = begin
      get_value alma_record['holding_data']['call_number']
    rescue StandardError
      'n/a'
    end
    # item.physical_description = get_value alma_record["holding_data"]["call_number"] rescue "n/a"

    item
  end

  def self.get_value(value)
    if value.nil?
      ''
    elsif value.is_a? Array
      if value.size > 1
        begin
          value.join(', ')
        rescue StandardError
          'n/a'
        end
      else
        begin
          value.try :first
        rescue StandardError
          'n/a'
        end
      end
    else
      value
    end
  end

  def self.configure
    Alma.configure do |config|
      config.apikey = PapyrusSettings.alma_apikey
      config.region = PapyrusSettings.alma_region
    end
  end
end
