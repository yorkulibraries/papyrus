class Term < ApplicationRecord
  # attr_accessible :name, :start_date, :end_date

  validates_presence_of :name, :start_date, :end_date
  validate :start_date_is_before_end_date

  has_many :courses

  default_scope { order('end_date desc') }

  scope :active, -> { where('end_date >= ?', Date.today) }
  scope :archived, -> { where('end_date < ?', Date.today) }

  private

  def start_date_is_before_end_date
    if end_date <= start_date
      errors.add(:base, 'End date must be after the start date')
      false
    else
      true
    end
  end
end
