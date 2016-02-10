class ScanList < ActiveRecord::Base

  # Fields : name, status, created_by, assigned_to

  ## RELATIONS
  belongs_to :created_by, class_name: "User"
  belongs_to :assigned_to, class_name: "User"

  ## AUDIT TRAIL
  audited

  ## CONSTANTS
  STATUS_NEW = "new"
  STATUS_SCANNING = "scanning"
  STATUS_DONE = "done"

  ## VALIDATIONS
  validates_presence_of :name, :status, :created_by

  ## METHODS
  def assignee
    if self[:assigned_to] == nil
      "Unassigned"
    else
      self[:assigned_to].name
    end
  end

end
