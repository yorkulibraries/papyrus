class ChangeFormatOtherToBool < ActiveRecord::Migration
  def change
    change_column :student_details, :format_other, :boolean
  end
end
