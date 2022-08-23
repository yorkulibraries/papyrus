# frozen_string_literal: true

class Attachment < ApplicationRecord
  # attr_accessible :name, :item_id, :file, :file_cache, :full_text, :url, :access_code_required, :is_url
  before_create :default_name

  validates_presence_of :file, message: 'Please select the file to upload.', unless: -> { is_url? }
  validates_presence_of :name, message: 'Enter the name of for this file.', unless: -> { is_url? }

  validates_presence_of :url, message: 'URL Address is required', if: -> { is_url? }

  mount_uploader :file, AttachmentUploader

  audited associated_with: :item

  belongs_to :item, counter_cache: true
  belongs_to :user

  default_scope { order('name') }

  scope :deleted, -> { where(deleted: true) }
  scope :available, -> { where(deleted: false) }

  scope :full_text, -> { where(full_text: true) }
  scope :not_full_text, -> { where("full_text = 'f' or full_text IS NULL") }

  scope :urls, -> { where(is_url: true) }
  scope :files, -> { where("is_url = 'f' or is_url IS NULL") }

  def destroy
    update_attribute(:deleted, true)
    Item.decrement_counter(:attachments_count, self[:item_id])
  end

  def default_name
    self.name ||= File.basename(file.filename, '.*').titleize if file
  end
end
