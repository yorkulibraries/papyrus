class AddFormatEPubToStudentDetails < ActiveRecord::Migration[5.1]
  def change
    add_column :student_details, :format_epub, :boolean
  end
end
