class ChangeFormatOtherToBool < ActiveRecord::Migration[4.2]
  def change
    change_column :student_details, :format_other, :boolean
  end
end
