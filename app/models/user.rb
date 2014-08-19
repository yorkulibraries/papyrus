class User < ActiveRecord::Base
  attr_accessible :username, :name, :role, :email
  acts_as_audited

  
  ADMIN = "admin"
  MANAGER = "manager"
  COORDINATOR = "coordinator"
  STAFF = "staff"
  PART_TIME ="part_time_staff"
  STUDENT_USER = "student"
  ACQUISITIONS = "acquisitions"
  ROLE_NAMES = [ADMIN, MANAGER, COORDINATOR, STAFF, PART_TIME, STUDENT_USER, ACQUISITIONS]
  ROLES = [[ADMIN.titleize, ADMIN], [MANAGER.titleize, MANAGER],  [COORDINATOR.titleize, COORDINATOR], [STAFF.titleize, STAFF], 
        [PART_TIME.titleize, PART_TIME], [ACQUISITIONS.titleize, ACQUISITIONS]]
  
  belongs_to :created_by, :foreign_key => "created_by_user_id"
  
  validates_presence_of :name, :username, :role
  validates_inclusion_of :role, in: ROLE_NAMES, allow_blank: false
  validates_format_of :username, :with => /^[-\w\._]+$/i, :allow_blank => false, :message => "should only contain letters, numbers, or .-_"
  validates_uniqueness_of :username
  validates_presence_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_uniqueness_of :email
   
  scope :active, where(:inactive => false).order("users.created_at desc")
  scope :inactive, where(:inactive => true).order("users.created_at desc")
  scope :not_students, where("users.role <> '#{STUDENT_USER}'")
  scope :transcription_assitants, where("users.role <> '#{STUDENT_USER}'").where("users.role <> '#{ACQUISITIONS}'")
  
  
  
  default_scope order("users.name asc")
  
  
end
