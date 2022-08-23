# frozen_string_literal: true

class Appointment < ApplicationRecord
  ## RELATIONSHIPS
  belongs_to :student
  belongs_to :user

  ## VALIDATIONS
  validates_presence_of :student, :title, :at

  ## SCOPES
  default_scope { order(:at) }
end
