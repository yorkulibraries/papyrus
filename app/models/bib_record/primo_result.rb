require 'primo'

class BibRecord::PrimoResult
  attr_accessor :title, :author, :isbn_issn, :callnumber, :publication_date, :publisher, :edition,
              :item_type, :format, :map_index_num, :journal_title, :volume, :page_number,
              :issue, :ils_barcode, :ils_id, :description, :main_location, :url, :rtype,
              :catalogue_record, :source, :subject, :language, :primo_id

  def self.search(search_string, max_number_of_results = 20)
    self.configure

    @query =  Primo::Search::Query.new(value: search_string)

    records = Primo.find(q: @query , limit: max_number_of_results)
    return process_primo_records records
  end

  def self.process_primo_records(records)
    return if records == nil

    results = []
    records.docs.each do |record|
      result = BibRecord::PrimoResult.new
      result.from_primo record
      pp record
      # pp  result.get_value(record[:pnx]["display"]["title"])
      # pp result.title
      results << result
    end

    results
  end

  def self.find_by_id(id)
    self.configure
    record = Primo.find_by_id(id: id, context: :PC)

  end

  def from_primo(record)
    self.primo_id = get_value record[:pnx]["control"]["sourcerecordid"]
    self.source = "primo"
    self.catalogue_record = record

    self.title = get_value record[:pnx]["display"]["title"]
    self.author = get_value record[:pnx]["sort"]["author"]
    self.item_type = get_value record[:pnx]["display"]["type"]
    self.description = get_value record[:pnx]["display"]["format"]
    self.edition = get_value record[:pnx]["display"]["edition"]
    self.publisher = get_value record[:pnx]["display"]["publisher"]
    self.language = get_value record[:pnx]["display"]["language"] rescue "n/a"
    self.subject = get_value record[:pnx]["display"]["subject"] rescue "n/a"
    self.publication_date = get_value record[:pnx]["addata"]["date"]
    self.callnumber = get_value record[:delivery]["holding"].first["callNumber"] rescue "n/a"
    self.main_location = get_value record[:delivery]["holding"].first["mainLocation"] rescue "n/a"
    self.isbn_issn = get_value record[:pnx]["addata"]["isbn"]
    self.ils_id = get_value record[:pnx]["display"]["mms"]

    ## journals
    self.isbn_issn = get_value record[:pnx]["addata"]["issn"] if isbn_issn.blank?
    self.journal_title = get_value record[:pnx]["addata"]["jtitle"]
    self.volume = get_value record[:pnx]["addata"]["volume"]
    self.issue = get_value record[:pnx]["addata"]["issue"]
    self.page_number = get_value(record[:pnx]["addata"]["spage"]) + " " + get_value(record[:pnx]["addata"]["epage"])
    self.url = get_value record[:pnx]["addata"]["url"]

    self.rtype = get_value record[:pnx]["search"]["rsrctype"] rescue nil

  end

  def get_value(value)
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


  def to_json
    require 'json'

    json = JSON.generate(
      { title: self.title,
        author: self.author,
        isbn_issn: self.isbn_issn,
        callnumber: self.callnumber,
        publication_date: self.publication_date,
        publisher: self.publisher,
        edition: self.edition,
        item_type: self.item_type,
        format: self.format,
        map_index_num: self.map_index_num,
        journal_title: self.journal_title,
        volume: self.volume,
        page_number: self.page_number,
        issue: self.issue,
        ils_barcode: self.ils_barcode,
        ils_id: self.ils_id,
        description: self.description,
        main_location: self.main_location,
        url: self.url,
        rtype: self.rtype
      }
    )

    json
  end

  def self.configure
    Primo.configure do |config|
      config.apikey = PapyrusSettings.primo_apikey
      config.inst = PapyrusSettings.primo_inst
      config.vid = PapyrusSettings.primo_vid
      config.region = PapyrusSettings.primo_region
      config.enable_loggable = PapyrusSettings.primo_enable_loggable
      config.scope = PapyrusSettings.primo_scope
      config.pcavailability = PapyrusSettings.primo_pcavailability
    end
  end

end
