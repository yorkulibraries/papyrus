class RemoveAndChangeFields < ActiveRecord::Migration
  def change

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

  end
end
