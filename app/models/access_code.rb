class AccessCode < ActiveRecord::Base
  attr_accessible :for, :code, :expires_at
  

  ## RELATIONS
  
  belongs_to :student
  belongs_to :created_by, class_name: "User"
  
  ## AUDIT TRAIL
  acts_as_audited associated_with: :student
  
  ## VALIDATIONS
  validates_presence_of :student, :created_by
  validates_presence_of :for, :code
  
  ## SCOPES
  scope :active,  where("expires_at >= ? OR expires_at is NULL", Date.today)
  scope :expired,  where("expires_at < ?", Date.today)
  default_scope order("expires_at ASC")
end
