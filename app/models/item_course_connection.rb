class ItemCourseConnection < ActiveRecord::Base
  belongs_to :item
  belongs_to :course, counter_cache: :items_count

  validates_uniqueness_of :course_id, scope: :item_id

  audited associated_with: :item
end
