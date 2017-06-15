class ScanList < ApplicationRecord 

  # Fields : name, status, created_by, assigned_to

  ## RELATIONS
  belongs_to :created_by, class_name: "User"
  belongs_to :assigned_to, class_name: "User"

  has_many :scan_items

  ## AUDIT TRAIL
  audited

  ## CONSTANTS
  STATUS_NEW = "new"
  STATUS_SCANNING = "scanning"
  STATUS_DONE = "done"

  SCAN_STATUSES = [STATUS_SCANNING, STATUS_DONE]

  ## VALIDATIONS
  validates_presence_of :name, :status, :created_by

  ## SCOPES
  scope :completed, -> { where(status: STATUS_DONE) }
  scope :not_completed, -> { where("scan_lists.status <> ? ", STATUS_DONE) }

  ## METHODS
  def assignee
    if self[:assigned_to_id] == nil
      "Unassigned"
    else
      assigned_to.name
    end
  end

  def creator
    if self[:created_by_id] == nil
      "System"
    else
      created_by.name
    end
  end

  def status_icon
    self[:status][0].upcase
  end

end
