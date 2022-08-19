class Document < ApplicationRecord
  ## Uploader ##
  mount_uploader :attachment, DocumentUploader

  ## RELATIONSHIPS ##
  belongs_to :attachable, polymorphic: true
  belongs_to :user

  ## VALIDATIONS ##
  validates_presence_of :attachment, message: 'Please select the file to upload.'
  validates_presence_of :name, message: 'Enter the name of for this file.'
  validates_presence_of :attachable_id, :attachable_type, :user_id

  ## Audited Setup ##
  audited associated_with: :attachable

  ## SCOPES ##
  default_scope { order('name') }

  scope :deleted, -> { where(deleted: true) }
  scope :available, -> { where(deleted: false) }

  ## Private methods
  def filename
    File.basename(attachment_url)
  end
end
