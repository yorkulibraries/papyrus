class CreateStudentDetails < ActiveRecord::Migration
  def self.up
    create_table :student_details do |t|
      t.integer :student_id
      t.integer :student_number
      t.string :home_phone
      t.string :campus_phone
      t.string :cell_phone
      t.string :work_phone
      t.boolean :di_ld
      t.boolean :di_low_vision
      t.boolean :di_blind
      t.boolean :di_braille_labels_required
      t.boolean :di_head_injury
      t.boolean :di_partially_sighted
      t.boolean :di_other
      t.text :di_note
      t.boolean :sp_psmds
      t.boolean :sp_lds
      t.boolean :sp_mhds
      t.boolean :sp_glendon_counselling
      t.string :cds_adviser
      t.boolean :format_pdf
      t.boolean :format_kurzweil
      t.boolean :format_daisy
      t.boolean :format_braille
      t.boolean  :format_word
      t.boolean  :format_large_print
      t.text :pf_note
      t.string :wrms_ref_number
      t.integer :transcription_coordinator_id, limit: 255
      t.integer  :transcription_assistant_id
      t.date :request_form_signed_on
      t.date :intake_appointment_on
      t.date :responsibilities_document_signed_on
      t.date :ppy_access_granted_on
      t.date :adaptive_computed_access_granted_on
      
      t.timestamps
    end
  end    

  def self.down
    drop_table :student_details
  end
end
