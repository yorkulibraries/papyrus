class ItemConnection < ApplicationRecord 
  # extra field  "expires_on"

  belongs_to :item
  belongs_to :student

  audited associated_with: :student

  validates_uniqueness_of :student_id, scope: [:item_id, :expires_on]


  scope :current, -> { where("expires_on >= ? OR expires_on IS ?", Date.today, nil) }
  scope :expired, -> { where("expires_on < ?", Date.today) }


end
