class Item < ActiveRecord::Base
  attr_accessible :title, :unique_id, :item_type, :callnumber, :author, :isbn, :publisher, :published_date, 
                  :language_note, :edition, :physical_description, :source, :source_note
  
  acts_as_audited
  has_associated_audits
  
  validates_presence_of :title, :unique_id, :item_type
  validates_uniqueness_of :unique_id
  
  paginates_per 20
  
  has_many :attachments 
  
  has_many :item_connections
  has_many :students, :through => :item_connections, :conditions =>  [ "item_connections.expires_on >= ? OR item_connections.expires_on IS ?", Date.today, nil]
  
  has_many :item_course_connections
  has_many :courses, :through => :item_course_connections
  
  has_many :acquisition_requests
  
  belongs_to :user
  
  scope :by_date, order("items.created_at desc")
  scope :alphabetical, order("items.title asc")
  
  scope :recently_worked_with, lambda { |user_id| 
    joins("INNER JOIN audits ON (audits.auditable_id = items.id OR audits.associated_id = items.id) AND (audits.auditable_type = 'Item' OR audits.associated_type = 'Item')")
    .where("audits.user_id = ?", user_id).reorder("audits.created_at desc").group("items.id") }
  
  BOOK = "book"
  COURSE_KIT = "course_kit"
  ARTICLE = "article"
  TYPES = [[BOOK.titleize, BOOK], [COURSE_KIT.titleize, COURSE_KIT], [ARTICLE.titleize, ARTICLE]]
  
  

  
  
  def assign_to_student(student, expire_on = nil)
     existing_connection = ItemConnection.where("student_id = ? AND item_id = ? AND (expires_on >= ? OR expires_on IS ?)", student.id, self.id, Date.today, nil).first
     
     # if we have an item_connection that has been expired, just return
     return existing_connection unless existing_connection == nil
     
     connection = ItemConnection.new
     connection.student = student
     connection.expires_on = expire_on unless expire_on.nil?
     connection.item = self
     connection.audit_comment = "Assigned - #{self.title}"
     connection.save
  end
  
  def withhold_from_student(student)
     # remove non-expired ones
     connection = ItemConnection.where("student_id = ? AND item_id = ? AND (expires_on >= ? OR expires_on IS ?)", student.id, self.id, Date.today, nil).first
     
     unless connection == nil
       connection.audit_comment = "Removed #{self.title}"
       connection.destroy
     end
  end
  
end
