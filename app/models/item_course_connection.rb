class ItemCourseConnection < ActiveRecord::Base
  belongs_to :item
  belongs_to :course
  
  validates_uniqueness_of :course_id, :scope => :item_id
  
  acts_as_audited :associated_with => :item
end
