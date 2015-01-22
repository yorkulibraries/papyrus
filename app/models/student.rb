class Student < User
  attr_accessible :name, :email, :username, :student_details_attributes
  paginates_per 18


  audited
  has_associated_audits

  has_many :notes
  has_many :access_codes

  has_one :student_details
  accepts_nested_attributes_for :student_details, allow_destroy: true

  has_many :item_connections
  has_many :items, through: :item_connections

  has_many :current_items, -> { where("item_connections.expires_on >= ? OR item_connections.expires_on IS ?", Date.today, nil) }, through: :item_connections, source: :item
  has_many :expired_items, -> { where("item_connections.expires_on < ?", Date.today) }, through: :item_connections, source: :item

  belongs_to :created_by, :foreign_key => "created_by_user_id", class_name: "User"


  # username, email, name and role are validated in the user class

  default_scope  { order("#{table_name}.created_at desc").includes(student_details: { transcription_coordinator: [] }) }

  scope :assigned_to, lambda { |user_id| joins(:student_details).
                              where("student_details.transcription_coordinator_id = ? OR student_details.transcription_assistant_id = ?", user_id, user_id)
                             }
  scope :unique_usernames, -> { group("username") }

  def to_csv
    [id, name, email, student_details.student_number, student_details.formats.join(", "), student_details.cds_counsellor, created_at]
  end

  def details
    if self.student_details.blank?
      return StudentDetails.new
    else
      return self.student_details
    end

    return self.student_details
  end

  def self.item_counts(student_ids, type = "current")
    counts = Hash.new
    connections = ItemConnection.select("student_id, count(*) as items_count").group(:student_id)
    connections = connections.where("student_id in(?)", student_ids) if student_ids.kind_of?(Array) && student_ids.size < 100

    case type
    when "expired"
      connections = connections.where("expires_on < ?", Date.today)
    when "current"
      connections = connections.where("expires_on >= ? OR expires_on IS ?", Date.today, nil)
    end

    connections.each do |c|
      counts[c.student_id] = c.items_count
    end

    counts
  end

  # Take in array of fields, and build a student attributes has with it
  def Student.build_hash_from_array(data, fields)
    hash = { student_details_attributes: {} }

    fields.each_with_index do |field, index|
      break if index > data.size

      case field
      when "first_name"
        hash[:first_name] = data[index]
      when "last_name"
        hash[:last_name] = data[index]
      when "email"
        hash[:email] = data[index]
      when "student_number"
        hash[:student_details_attributes][:student_number] = data[index]
      when "cds_counsellor"
        hash[:student_details_attributes][:cds_counsellor]  = data[index]
      when "cds_counsellor_email"
        hash[:student_details_attributes][:cds_counsellor_email]  = data[index]
      when "request_form_signed_on"
        hash[:student_details_attributes][:request_form_signed_on]  = data[index]
      when "accessibility_lab_access"
        hash[:student_details_attributes][:accessibility_lab_access]  =  data[index].try(:downcase) == "true" ? true : false
      when "book_retrieval"
        hash[:student_details_attributes][:book_retrieval]  =  data[index].try(:downcase) == "true" ? true : false
      when "alternate_format_required"
        hash[:student_details_attributes][:alternate_format_required]  =  data[index].try(:downcase) == "true" ? true : false
      when "format_pdf"
        hash[:student_details_attributes][:format_pdf]  =  data[index].try(:downcase) == "true" ? true : false
      when "format_large_print"
        hash[:student_details_attributes][:format_large_print]  = data[index].try(:downcase) == "true" ? true : false
      when "format_daisy"
        hash[:student_details_attributes][:format_daisy]  = data[index].try(:downcase) == "true" ? true : false
      when "format_braille"
        hash[:student_details_attributes][:format_braille]  = data[index].try(:downcase) == "true" ? true : false
      when "format_kurzweil"
        hash[:student_details_attributes][:format_kurzweil] = data[index].try(:downcase) == "true" ? true : false
      when "format_word"
        hash[:student_details_attributes][:format_word]  =  data[index].try(:downcase) == "true" ? true : false
      when "format_other"
        hash[:student_details_attributes][:format_other]  =  data[index].try(:downcase) == "true" ? true : false
      when "format_note"
        hash[:student_details_attributes][:format_note]  = data[index]
      else
        # can't update the field
      end
    end

    # return HASH
    hash

  end
end
