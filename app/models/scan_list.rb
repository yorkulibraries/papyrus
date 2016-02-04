class ScanList < ActiveRecord::Base

  # Fields : name, status, created_by

  ## RELATIONS
  belongs_to :created_by, class_name: "User"

  ## AUDIT TRAIL
  audited

  ## CONSTANTS
  STATUS_NEW = "new"
  STATUS_SCANNING = "scanning"
  STATUS_DONE = "done"

  ## VALIDATIONS
  validates_presence_of :name, :status, :created_by


end
