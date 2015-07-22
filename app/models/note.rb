class Note < ActiveRecord::Base
  #attr_accessible :note

  default_scope { order("created_at desc") }
  belongs_to :student

  validates_presence_of :note, :message => "Note field must not be empty"

  belongs_to :user

  audited :associated_with => :student

  def self.EDIT_TIME
    5.minutes
  end

  def editable_time
    created_at + Note.EDIT_TIME
  end

end
