class Student < User
  attr_accessible :name, :email, :username, :student_details_attributes
  paginates_per 18
 
 
  acts_as_audited
  has_associated_audits
  
  has_many :notes
  
  has_one :student_details
  accepts_nested_attributes_for :student_details, :allow_destroy => true
  
  has_many :item_connections
  has_many :items, :through => :item_connections
  has_many :current_items, :through => :item_connections, :source => :item, :conditions => [ "item_connections.expires_on >= ? OR item_connections.expires_on IS ?", Date.today, nil]
  has_many :expired_items, :through => :item_connections, :source => :item, :conditions => [ "item_connections.expires_on < ?", Date.today]  
  
  belongs_to :created_by, :foreign_key => "created_by_user_id", :class_name => "User"
  
  
  # username, email, name and role are validated in the user class
 
    
  default_scope order("#{table_name}.created_at desc").includes(:student_details)
  
  scope :assigned_to, lambda { |user_id| joins(:student_details).
                              where("student_details.transcription_coordinator_id = ? OR student_details.transcription_assistant_id = ?", user_id, user_id)
                             }
  scope :unique_usernames, group: "username"                           
                             
  def to_csv
    [id, name, email, student_details.student_number, student_details.cds_adviser, created_at]
  end
  
  def details
    if self.student_details.blank?      
      return StudentDetails.new 
    else
      return self.student_details
    end
  end

end
