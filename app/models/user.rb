class User < ApplicationRecord
  #attr_accessible :username, :first_name, :last_name, :role, :email
  audited


  ## CONTSTANTS

  # Roles

  ADMIN = "admin"
  MANAGER = "manager"
  COORDINATOR = "coordinator"
  STAFF = "staff"
  PART_TIME ="part_time_staff"
  STUDENT_VIEW = "student_view_only"
  STUDENT_USER = "student"
  ROLE_NAMES = [ADMIN, MANAGER, COORDINATOR, STAFF, PART_TIME, STUDENT_VIEW, STUDENT_USER]
  ROLES = [[ADMIN.titleize, ADMIN], [MANAGER.titleize, MANAGER],  [COORDINATOR.titleize, COORDINATOR], [STAFF.titleize, STAFF],
        [PART_TIME.titleize, PART_TIME],[STUDENT_VIEW.titleize, STUDENT_VIEW]]

  # Activity Names
  ACTIVITY_GENERAL = "general"
  ACTIVITY_LOGIN = "login"
  ACTIVITY_LOGOUT = "logout"

  ## RELATIONS

  belongs_to :created_by, foreign_key: "created_by_user_id"


  ## VALIDATIONS

  validates_presence_of :first_name, :last_name, :username, :role
  validates_inclusion_of :role, in: ROLE_NAMES, allow_blank: false
  validates_format_of :username, with: /\A[-\w\._]+\z/i, allow_blank: false, message: "should only contain letters, numbers, or .-_"
  validates_uniqueness_of :username
  validates_presence_of :email
  validates_format_of :email, with: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
  validates_uniqueness_of :email

  ## SCOPES

  scope :active, -> { where(inactive: false).order("users.created_at desc") }
  scope :inactive, -> { where(inactive: true).order("users.created_at desc") }
  scope :unblocked, -> { where(blocked: false) }
  scope :blocked, -> { where(blocked: true) }
  scope :not_students, -> { where("users.role <> '#{STUDENT_USER}'") }
  scope :transcription_assitants, -> { where("users.role <> '#{STUDENT_USER}'").where("users.role <> '#{ADMIN}'") }
  scope :coordinators, -> { where(role: COORDINATOR) }

  scope :ordered_by_last_name, -> { order("users.last_name asc") }

  ## INSTANCE FUNCTIONS

  def initials
    self.name.split(/\s+/).map(&:first).join.upcase
  end

  def blocked?
    self[:blocked] == true
  end
  
  def name
    "#{self.first_name} #{self.last_name}".strip
  end

  def name=(name)
    self.last_name = name
  end

  def active_now!(action=ACTIVITY_GENERAL)
    now = Time.now



    if action == ACTIVITY_LOGIN
      self.last_logged_in_at = now
      self.last_active_at = now
      self.inactive = false
      self.audit_comment = self.last_logged_in_at.strftime("Logged in on %b %d, %Y at %I:%M%p")
      save(validate: false)
    else

      self.last_active_at = now
      # Don't audit activity
      self.without_auditing do
        save(validate: false)
      end
    end



  end


  def work_history(max=20)
    Audited::Audit.where(user_id: self[:id]).order("created_at desc").limit(max)
  end

  ## CLASS FUNCTIONS

end
