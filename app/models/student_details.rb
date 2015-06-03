class StudentDetails < ActiveRecord::Base
  attr_accessible  :student_number, :preferred_phone, :request_form_signed_on,
                   :format_large_print, :format_pdf, :format_kurzweil, :format_daisy, :format_braille, :format_word, :format_note, :format_other,
                   :transcription_coordinator_id, :transcription_assistant_id, :cds_counsellor, :cds_counsellor_email, :book_retrieval,
                   :requires_orientation, :orientation_completed, :orientation_completed_at, :accessibility_lab_access, :alternate_format_required

  belongs_to :student
  belongs_to :transcription_coordinator, class_name: "User", foreign_key: "transcription_coordinator_id"
  belongs_to :transcription_assistant, class_name: "User", foreign_key: "transcription_assistant_id"

  audited associated_with: :student

  validates_presence_of :student_number, :preferred_phone, :cds_counsellor
  validates_presence_of  :transcription_coordinator, message: "You must specify a transcription coordinator."
  validates_presence_of :transcription_assistant, message: "You must specify a transcritpion assistant"


  def coordinator
    if self.transcription_coordinator.blank?
      return User.new
    else
      return self.transcription_coordinator
    end
  end

  def assistant
    if self.transcription_assistant.blank?
      return User.new
    else
      return self.transcription_assistant
    end
  end


  def formats
    formats_array = Array.new
    formats_array.push "PDF" if self.format_pdf
    formats_array.push "KURZWEIL" if self.format_kurzweil
    formats_array.push "DAISY" if self.format_daisy
    formats_array.push "BRAILLE" if self.format_braille
    formats_array.push "WORD DOCUMENT" if self.format_word
    formats_array.push "LARGE PRINT" if self.format_large_print

    formats_array
  end

  def complete_orientation
    self.orientation_completed = true
    self.orientation_completed_at = Date.today
    self.audit_comment = "Orientation Completed"
    save(valudate: false)
  end


end
