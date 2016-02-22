class ScanItem < ActiveRecord::Base
  # Fields: :summary, :item_id, :scan_list_id, :assigned_to_id, :created_by_id, :due_date, :status

  ## RELATIONS
  belongs_to :created_by, class_name: "User"
  belongs_to :assigned_to, class_name: "User"
  belongs_to :item
  belongs_to :scan_list, class_name: "ScanList"

  ## AUDIT TRAIL
  audited

  ## CONSTANTS
  STATUS_NEW = "new"
  STATUS_DONE = "done"

  SCAN_STATUSES = [STATUS_NEW, STATUS_DONE]

  ## VALIDATIONS
  validates_presence_of :summary, :status, :created_by, :scan_list, :item

  ## SCOPES
  scope :completed, -> { where(status: STATUS_DONE) }
  scope :not_completed, -> { where("status <> ? ", STATUS_DONE) }

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


end
