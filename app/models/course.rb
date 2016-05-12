class Course < ActiveRecord::Base
  #attr_accessible :title, :code

  ## RELATIONSHIPS ##
  belongs_to :term, counter_cache: true

  has_many :documents, as: :attachable

  has_many :item_course_connections
  has_many :items, through: :item_course_connections

  has_many :student_courses
  has_many :students, through: :student_courses

  has_one :syllabus, -> { where deleted: false }, as: :attachable,  class_name: "Document"

  ## VALIDATIONS ##
  validates_presence_of :title, :code, :term_id
  validates_uniqueness_of :code

  ## SCOPES ##
  default_scope  { order('title ASC') }


  ## METHODS ##
  def add_item(item)
    unless item == nil
      item_course = item_course_connections.build
      item_course.item = item
      item_course.audit_comment = "Added a Item to the course #{self["code"]}"
      item_course.save
    end
  end

  def remove_item(item)
    unless item == nil
      item_course = item_course_connections.find_by_item_id(item.id)
      item_course.audit_comment = "Removed an Item from the course #{self["code"]}"
      item_course.destroy
    end
  end


  ## Student ##
  def enroll_student(student)
    unless student == nil
      student_course = student_courses.build
      student_course.student = student
      student_course.audit_comment = "Enrolled student in #{self[:title]} course"
      student_course.save
    end
  end

  def withdraw_student(student)
    unless student == nil
      student_course = student_courses.find_by_student_id(student.id)
      student_course.audit_comment = "Withdrawn student in #{self[:title]} course"
      student_course.destroy
    end
  end


  def Course.search(query)
    q_like = "%#{query}%"
     Course.joins(:term).where("terms.end_date >= '#{Date.today}'").where("courses.title like ? OR courses.code like ? ", q_like, q_like)
  end

  def short_name
    chunks = self[:code].split("_")
    return "#{chunks[2]} #{chunks[4]}"
  end

end
