# frozen_string_literal: true

class Announcement < ApplicationRecord
  ## AUDIT TRAIL
  audited associated_with: :user

  ## CONSTANTS
  AUDIENCE_STUDENT = 'Student'
  AUDIENCE_USER = 'User'
  AUDIENCES = [AUDIENCE_USER, AUDIENCE_STUDENT].freeze

  ## RELATIONS
  belongs_to :user

  ## VALIDATIONS
  validates_presence_of :ends_at, :message, :starts_at, :audience
  validates_presence_of :user

  ## SCOPES
  scope :expired, -> {  where('ends_at < ?', Date.today) }
  scope :non_expired, -> { where('ends_at >= ?', Date.today) }
  scope :activated, lambda {
    where('(active = TRUE) AND (starts_at <= :now AND ends_at >= :now)', now: Time.zone.now)
  }
  scope :visible, -> { activated.count }

  ## INSTANCE METHODS
  def self.current(hidden_ids = nil, audience = nil)
    result = activated
    result = result.where('id not in (?)', hidden_ids) if hidden_ids.present?

    # taylor to different audiences
    case audience&.capitalize
    when AUDIENCE_STUDENT
      result.where('audience = ?', AUDIENCE_STUDENT)
    when 'Student_view_only'
      result.where('audience = ?', AUDIENCE_STUDENT)
    when AUDIENCE_USER
      result.where('audience = ?', AUDIENCE_USER)
    else
      result.where('audience = ? OR audience = ?', AUDIENCE_USER, AUDIENCE_STUDENT)
    end
  end
end
