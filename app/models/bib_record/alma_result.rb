require 'alma'
class BibRecord::AlmaResult

  def self.find_item(id)
    self.configure
    items = Alma::BibItem.find(id)
    return items.first
  end

  def self.build_item_from_alma_result(alma_record)
    return Item.new if alma_record == nil || alma_record["bib_data"] == nil

    id = get_value alma_record["bib_data"]["mms_id"] rescue ""
    item = Item.new
    item.item_type = Item::BOOK
    item.title = get_value alma_record["bib_data"]["title"] rescue "n/a"
    item.unique_id = "alma_#{id}"
    item.author = get_value alma_record["bib_data"]["author"] rescue "n/a"
    item.isbn = get_value alma_record["bib_data"]["isbn"] rescue "n/a"
    publisher1 = get_value alma_record["bib_data"]["place_of_publication"] rescue "n/a"
    publisher2 = get_value(alma_record["bib_data"]["publisher_const"]) rescue ""

    item.publisher = "#{publisher1} #{publisher2}"
    item.published_date = get_value alma_record["bib_data"]["date_of_publication"] rescue "n/a"
    item.edition = get_value alma_record["bib_data"]["complete_edition"] rescue "n/a"
    item.callnumber = get_value alma_record["holding_data"]["call_number"] rescue "n/a"
    #item.physical_description = get_value alma_record["holding_data"]["call_number"] rescue "n/a"

    return item
  end

  def self.get_value(value)
    if value == nil
      return ""
    elsif value.is_a? Array
      if value.size > 1
        return value.join(", ") rescue "n/a"
      else
        return value.try :first rescue "n/a"
      end
    else
      return value
    end
  end

  def self.configure
    Alma.configure do |config|
      config.apikey = PapyrusSettings.alma_apikey
      config.region = PapyrusSettings.alma_region
    end
  end
end
