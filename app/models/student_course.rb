class StudentCourse < ApplicationRecord 

  ## RELATIONSHIPS ##
  belongs_to :student
  belongs_to :course

  ## VALIDATIONS ##
  validates_uniqueness_of :course_id, scope: :student_id

  ## Audited ##
  audited associated_with: :student
end
