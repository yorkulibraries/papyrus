class AccessCode < ApplicationRecord 
  #attr_accessible :for, :code, :expires_at


  ## RELATIONS

  belongs_to :student
  belongs_to :created_by, class_name: "User"

  ## AUDIT TRAIL
  audited associated_with: :student

  ## VALIDATIONS
  validates_presence_of :created_by
  validates_presence_of :student, unless: :shared
  validates_presence_of :for, :code

  ## SCOPES
  default_scope { order("expires_at ASC") }
  scope :active, -> { where("expires_at >= ? OR expires_at is NULL", Date.today) }
  scope :expired, -> { where("expires_at < ?", Date.today) }

  scope :shared, -> { where(shared: true) }
  scope :personal, -> { where(shared: false) }

  def expired?
    if self[:expires_at] != nil
      self[:expires_at] < Date.today
    else
      false
    end
  end

end
