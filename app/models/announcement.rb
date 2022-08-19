class Announcement < ApplicationRecord
  # attr_accessible :ends_at, :message, :starts_at, :audience, :active

  ## AUDIT TRAIL
  audited associated_with: :user

  ## CONSTANTS
  AUDIENCE_STUDENT = 'Student'
  AUDIENCE_USER = 'User'
  AUDIENCES = [AUDIENCE_USER, AUDIENCE_STUDENT]

  ## RELATIONS
  belongs_to :user

  ## VALIDATIONS
  validates_presence_of :ends_at, :message, :starts_at, :audience
  validates_presence_of :user

  ## SCOPES
  scope :expired, -> {  where('ends_at < ?', Date.today) }
  scope :non_expired, -> { where('ends_at >= ?', Date.today) }
  scope :active, -> { where('active = ?', true) }

  ## INSTANCE METHODS
  def self.current(hidden_ids = nil, audience = nil)
    result = where('starts_at <= :now and ends_at >= :now', now: Time.zone.now)
    result = result.where('id not in (?)', hidden_ids) if hidden_ids.present?

    # taylor to different audiences
    if audience == AUDIENCE_USER
      result = result.where('audience = ?', AUDIENCE_USER)
    elsif audience == AUDIENCE_STUDENT
      result = result.where('audience = ?', AUDIENCE_STUDENT)
    end

    result
  end
end
