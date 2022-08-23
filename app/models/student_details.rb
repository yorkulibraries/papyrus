# frozen_string_literal: true

class StudentDetails < ApplicationRecord
  # attr_accessible  :student_number, :preferred_phone, :request_form_signed_on,
  #                 :format_large_print, :format_pdf, :format_kurzweil, :format_daisy, :format_braille, :format_word, :format_note, :format_other,
  #                 :transcription_coordinator_id, :transcription_assistant_id, :cds_counsellor, :cds_counsellor_email, :book_retrieval,
  #                 :requires_orientation, :orientation_completed, :orientation_completed_at, :accessibility_lab_access, :alternate_format_required

  belongs_to :student

  belongs_to :transcription_coordinator, class_name: 'User', foreign_key: 'transcription_coordinator_id'
  belongs_to :transcription_assistant, class_name: 'User', foreign_key: 'transcription_assistant_id'

  audited associated_with: :student

  validates_presence_of :student_number, :preferred_phone
  validates_presence_of :transcription_coordinator, message: 'You must specify a transcription coordinator.'
  validates_presence_of :transcription_assistant, message: 'You must specify a transcritpion assistant'

  def coordinator
    if transcription_coordinator.blank?
      User.new
    else
      transcription_coordinator
    end
  end

  def assistant
    if transcription_assistant.blank?
      User.new
    else
      transcription_assistant
    end
  end

  def formats
    formats_array = []
    formats_array.push 'PDF' if format_pdf
    formats_array.push 'KURZWEIL' if format_kurzweil
    formats_array.push 'DAISY' if format_daisy
    formats_array.push 'BRAILLE' if format_braille
    formats_array.push 'WORD DOCUMENT' if format_word
    formats_array.push 'LARGE PRINT' if format_large_print
    formats_array.push 'EPUB' if format_epub

    formats_array
  end

  def complete_orientation
    self.orientation_completed = true
    self.orientation_completed_at = Date.today
    self.audit_comment = 'Orientation Completed'
    save(valudate: false)
  end
end
