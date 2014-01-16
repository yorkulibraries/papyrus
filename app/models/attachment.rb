class Attachment < ActiveRecord::Base
  attr_accessible :name, :item_id, :file, :file_cache, :full_text
  
  validates_presence_of :file, message: "Please select the file to upload."
  validates_presence_of :name, message: "Enter the name of for this file."
  
  
  mount_uploader :file, AttachmentUploader
  
  acts_as_audited associated_with: :item
  
  belongs_to :item, counter_cache: true
  belongs_to :user
  
  
  default_scope order("name")
  
  scope :deleted, where(:deleted => true)
  scope :available, where(:deleted => false)
  
  scope :full_text, where(full_text: true)
  scope :not_full_text, where(full_text: false)
  
  
  def destroy 
    update_attribute(:deleted, true)        
    Item.decrement_counter(:attachments_count, self[:item_id])
  end
  
end
