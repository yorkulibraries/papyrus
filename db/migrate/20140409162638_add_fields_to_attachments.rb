class AddFieldsToAttachments < ActiveRecord::Migration[4.2]
  def change
    add_column :attachments, :is_url, :boolean, default: false
    add_column :attachments, :url, :string
    add_column :attachments, :access_code_required, :boolean, default: false
  end
end
