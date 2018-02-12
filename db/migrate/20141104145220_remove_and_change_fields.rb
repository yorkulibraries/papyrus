class RemoveAndChangeFields < ActiveRecord::Migration[4.2]
  def change

   # Rename Indexes
   remove_index :student_details, [:transcription_coordinator_id] if index_exists?(:student_details, :transcription_coordinator_id)
   remove_index :student_details, [:transcription_assistant_id] if index_exists?(:student_details, :transcription_assistant_id)
   add_index :student_details, [:transcription_assistant_id], name: "ta_id"
   add_index :student_details, [:transcription_coordinator_id], name: "tc_id"

    # contact phone numbers
    remove_column :student_details, :campus_phone
    remove_column :student_details, :work_phone
    remove_column :student_details, :home_phone
    rename_column :student_details, :cell_phone, :preferred_phone

    # disablity information
    remove_column :student_details, :di_ld
    remove_column :student_details, :di_low_vision
    remove_column :student_details, :di_blind
    remove_column :student_details, :di_braille_labels_required
    remove_column :student_details, :di_head_injury
    remove_column :student_details, :di_partially_sighted
    remove_column :student_details, :di_other
    remove_column :student_details, :di_note

    # service provider
    remove_column :student_details, :sp_psmds
    remove_column :student_details, :sp_lds
    remove_column :student_details, :sp_mhds
    remove_column :student_details, :sp_glendon_counselling

    # Other unused fields
    remove_column :student_details, :wrms_ref_number
    remove_column :student_details, :ppy_access_granted_on
    remove_column :student_details, :adaptive_computed_access_granted_on
    remove_column :student_details, :intake_appointment_on
    remove_column :student_details, :responsibilities_document_signed_on

    # Rename format field
    rename_column :student_details, :pf_note, :format_note

    # Add CDS Fields
    add_column :student_details, :book_retrieval, :boolean, default: false
    add_column :student_details, :accessibility_lab_access, :boolean, default: false
    add_column :student_details, :cds_counsellor_email, :string
    add_column :student_details, :alternate_format_required, :boolean, default: true
    add_column :student_details, :format_other, :string
    rename_column :student_details, :cds_adviser, :cds_counsellor

    # Name to be split
    add_column :users, :first_name, :string
    rename_column :users, :name, :last_name

    # Additional field for access_codes
    add_column :access_codes, :shared, :boolean, default: false

  end
end
