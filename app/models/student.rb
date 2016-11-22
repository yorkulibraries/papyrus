class Student < User
  #attr_accessible :name, :email, :username, :student_details_attributes

  ## PLUGINS ##
  paginates_per 18
  audited
  has_associated_audits

  ## RELATIONSHIPS ##
  has_many :notes
  has_many :access_codes

  has_one :student_details
  has_many :item_connections
  has_many :items, through: :item_connections

  has_many :student_courses
  has_many :courses, through: :student_courses

  has_many :current_items, -> { where("item_connections.expires_on >= ? OR item_connections.expires_on IS ?", Date.today, nil) }, through: :item_connections, source: :item
  has_many :expired_items, -> { where("item_connections.expires_on < ?", Date.today) }, through: :item_connections, source: :item


  belongs_to :created_by, :foreign_key => "created_by_user_id", class_name: "User"

  has_many :documents, as: :attachable
  ## ATTRIBUTES ##
  accepts_nested_attributes_for :student_details, allow_destroy: true

  ## VALIDATIONS ##
  # username, email, name and role are validated in the user class

  ## SCOPES ##
  default_scope  { order("#{table_name}.created_at desc").includes(student_details: { transcription_coordinator: [] }) }

  scope :assigned_to, lambda { |user_id| joins(:student_details).
                              where("student_details.transcription_coordinator_id = ? OR student_details.transcription_assistant_id = ?", user_id, user_id)
                             }
  scope :unique_usernames, -> { group("username") }

  scope :recently_worked_with, lambda { |user_id|
    joins("INNER JOIN audits ON (audits.auditable_id = users.id OR audits.associated_id = users.id) AND (audits.auditable_type = 'User' OR audits.associated_type = 'StudentDetails')")
    .where("audits.user_id = ?", user_id).reorder("audits.created_at desc").group("users.id") }

  scope :lab_access_only, -> { joins(:student_details)
    .where("format_pdf IS NULL OR format_pdf = ?", false)
    .where("format_kurzweil IS NULL OR format_kurzweil = ?", false)
    .where("format_daisy IS NULL OR format_daisy = ?", false)
    .where("format_braille IS NULL OR format_braille = ?", false)
    .where("format_word IS NULL OR format_word = ?", false)
    .where("format_large_print IS NULL OR format_large_print = ?", false)
    .where("format_other IS NULL OR format_other = ?", false)
    }

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

  def formats_array
    formats_array = Array.new
    formats_array.push "PDF" if self.details.format_pdf
    formats_array.push "KURZWEIL" if self.details.format_kurzweil
    formats_array.push "DAISY" if self.details.format_daisy
    formats_array.push "BRAILLE" if self.details.format_braille
    formats_array.push "WORD" if self.details.format_word
    formats_array.push "LARGE PRINT" if self.details.format_large_print
    formats_array.push "OTHER" if self.details.format_other
    return formats_array
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
