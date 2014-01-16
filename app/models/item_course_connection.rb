class ItemCourseConnection < ActiveRecord::Base
  belongs_to :item
  belongs_to :course, counter_cache: :items_count
  
  validates_uniqueness_of :course_id, scope: :item_id
  
  acts_as_audited associated_with: :item
end
