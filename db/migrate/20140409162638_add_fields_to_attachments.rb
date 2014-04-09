class AddFieldsToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :is_url, :boolean, default: false
    add_column :attachments, :url, :string
    add_column :attachments, :access_code_required, :boolean, default: false
  end
end
