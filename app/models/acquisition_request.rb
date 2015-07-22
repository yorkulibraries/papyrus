class AcquisitionRequest < ActiveRecord::Base
  #attr_accessible :notes

  belongs_to :item
  belongs_to :requested_by, :class_name => "User", :foreign_key => "requested_by_id"
  belongs_to :fulfilled_by, :class_name => "User", :foreign_key => "fulfilled_by_id"
  belongs_to :cancelled_by, :class_name => "User", :foreign_key => "cancelled_by_id"


  validates_presence_of :item
  validates_presence_of :requested_by, :requested_by_date


  scope :pending, -> { where(:fulfilled => false).where(:cancelled => false).order("requested_by_date asc") }
  scope :fulfilled, -> { where(:fulfilled => true).where(:cancelled => false).order("requested_by_date desc") }
  scope :cancelled, -> { where(:cancelled => true).order("requested_by_date desc") }




  def cancell(user)
    return if user == nil
    self.cancelled = true
    self.cancelled_by = user
    self.cancelled_by_date = Date.today
    save(:validate => false)
  end

  def destroy
    raise "Not Implemeted Error, use AcquisitionRequest.cancell(by whom)"
  end

  def fulfill(user)
    return if user == nil

    self.fulfilled = true
    self.fulfilled_by = user
    self.fulfilled_by_date = Date.today
    save(:validate => false)
  end

end
