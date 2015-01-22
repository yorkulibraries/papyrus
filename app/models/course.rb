class Course < ActiveRecord::Base
  attr_accessible :title, :code

  belongs_to :term, counter_cache: true

  validates_presence_of :title, :code, :term_id
  validates_uniqueness_of :code

  default_scope  { order: 'title ASC' }

  has_many :item_course_connections
  has_many :items, :through => :item_course_connections


  def add_item(item)
    unless item == nil
      item_course = item_course_connections.build
      item_course.item = item
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
     Course.joins(:term).where("terms.end_date >= '#{Date.today}'").where("courses.title like \"%#{query}%\" OR courses.code like \"%#{query}%\" ")
  end

end
