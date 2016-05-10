class Document < ActiveRecord::Base

  ## Uploader ##
  mount_uploader :attachment, DocumentUploader

  ## RELATIONSHIPS ##
  belongs_to :attachable, polymorphic: true
  belongs_to :user

  ## VALIDATIONS ##
  validates_presence_of :attachment, message: "Please select the file to upload.", unless: lambda { is_url? }
  validates_presence_of :name, message: "Enter the name of for this file.", unless: lambda { is_url? }
  validates_presence_of :attachable_id, :attachable_type

  ## Audited Setup ##
  audited associated_with: :student

  ## SCOPES ##
  default_scope { order("name") }

  scope :deleted, -> { where(deleted: true) }
  scope :available, -> { where(deleted: false) }

end
