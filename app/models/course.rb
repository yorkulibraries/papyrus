class Course < ActiveRecord::Base
  #attr_accessible :title, :code

  ## RELATIONSHIPS ##
  belongs_to :term, counter_cache: true

  has_many :documents, as: :attachable

  has_many :item_course_connections
  has_many :items, :through => :item_course_connections

  has_one :syllabus, as: :attachable

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
      #item_course.audited_comment = "Added a Item to the course #{self["code"]}"
      item_course.save
    end
  end

  def remove_item(item)
    unless item == nil
      item_course = item_course_connections.find_by_item_id(item.id)
      item_course.destroy
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
