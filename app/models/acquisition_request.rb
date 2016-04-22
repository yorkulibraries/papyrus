class AcquisitionRequest < ActiveRecord::Base

  ##### DB Fields for reference (update if changes)
  # "id", "item_id", "requested_by_id", "acquisition_reason", "status", "location_id",
  # "back_ordered_until",
  # "cancelled_by_id", "cancellation_reason", "cancelled_at", "acquired_by_id", "acquired_at",
  # "acquisition_notes", "acquisition_source_type", "acquisition_source_name", "created_at", "updated_at"
  #####

  ## Audited
  audited

  ## CONSTANTS
  STATUS_OPEN="open"
  STATUS_BACK_ORDERED="back_ordered"
  STATUS_ACQUIRED="acquired"
  STATUS_CANCELLED="cancelled"
  STATUSES=[STATUS_ACQUIRED, STATUS_CANCELLED, STATUS_BACK_ORDERED]

  ## RELATIONS
  belongs_to :item
  belongs_to :requested_by, class_name: "User", foreign_key: "requested_by_id"
  belongs_to :acquired_by, class_name: "User", foreign_key: "acquired_by_id"
  belongs_to :cancelled_by, class_name: "User", foreign_key: "cancelled_by_id"
  belongs_to :back_ordered_by, class_name: "User", foreign_key: "back_ordered_by_id"

  ## VALIDATIONS
  validates_presence_of :item, :requested_by  ## default basic validation
  validates_presence_of :acquired_by, :acquired_at, :acquisition_source_type, :acquisition_source_name, if: lambda { self.status == STATUS_ACQUIRED }
  validates_presence_of :cancelled_by, :cancelled_at, :cancellation_reason, if: lambda { self.status == STATUS_CANCELLED }

  ## SCOPES

  scope :open, -> { where(status: nil) }
  scope :back_ordered, -> { where(status: STATUS_BACK_ORDERED) }
  scope :acquired, -> { where(status: STATUS_ACQUIRED) }
  scope :cancelled, -> { where(status: STATUS_CANCELLED) }
  scope :by_source_type, -> (source) { where("acquisition_source_type = ? ", source) }
  scope :open_back_ordered, -> { where("status = ? or status = ?", nil, STATUS_BACK_ORDERED) }


  ## Helper Methods
  def status
    if self[:status] == nil
      STATUS_OPEN
    else
      self[:status]
    end
  end

  def available_after
    if self[:back_ordered_until] == nil
      "Unknown"
    else
      self[:back_ordered_until]
    end
  end


end
