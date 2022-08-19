class ItemCourseConnection < ApplicationRecord
  ## RELATIONSHIPS ##
  belongs_to :item
  belongs_to :course, counter_cache: :items_count

  ## VALIDATIONS ##
  validates_uniqueness_of :course_id, scope: :item_id

  ## Audited ##
  audited associated_with: :item
end
