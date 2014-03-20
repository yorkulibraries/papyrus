class StudentDetails < ActiveRecord::Base
  attr_accessible  :student_number, :home_phone, :campus_phone, :cell_phone, :work_phone, 
                    :di_ld, :di_low_vision, :di_blind, :di_braille_labels_required, :di_head_injury, :di_partially_sighted, :di_other, :di_note, 
                    :sp_psmds, :sp_lds, :sp_mhds, :sp_glendon_counselling,
                    :format_large_print, :format_pdf, :format_kurzweil, :format_daisy, :format_braille, :format_word, :pf_note, :wrms_ref_number, 
                    :transcription_coordinator_id, :transcription_assistant_id, :cds_adviser,
                    :request_form_signed_on, :intake_appointment_on, :responsibilities_document_signed_on, 
                    :ppy_access_granted_on, :adaptive_computed_access_granted_on, :requires_orientation, :orientation_completed, :orientation_completed_at
                    
  belongs_to :student
  belongs_to :transcription_coordinator, class_name: "User", foreign_key: "transcription_coordinator_id"
  belongs_to :transcription_assistant, class_name: "User", foreign_key: "transcription_assistant_id"
  
  acts_as_audited associated_with: :student
  

  validates_presence_of :student_number, :cell_phone, :cds_adviser
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
  
  
  def complete_orientation
    update_attributes(orientation_completed: true, orientation_completed_at: Date.today)
  end
  
  
end
