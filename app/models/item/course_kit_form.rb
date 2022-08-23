# frozen_string_literal: true

class Item::CourseKitForm
  include ActiveModel::Validations

  # COURSE FORMAT
  # YEAR_FACULTY_SUBJECT_TERM_COURSEID__CREDITS_SECTION    i.e. 2013_GL_ECON_S1_2500__3_A ignoring EN_A_LECT_01

  # CONSTANTS
  FACULTIES = %w[AP ED ES FA GL GS HH LE LIB LW S SB SC SCS YUL].freeze
  SECTIONS = ('A'..'Z')

  ACADEMIC_YEARS = if Date.today.month > 8
                     Date.today.year..Date.today.year + 1
                   else
                     Date.today.year - 1..Date.today.year
                   end

  ACADEMIC_YEARS_FULL = ACADEMIC_YEARS.collect { |year| ["#{year}/#{year + 1}", year] }

  TERMS = %w[F W FW Y S SU S1 S2].freeze
  TERM_NAMES = %w[Fall Winter Fall/Winter Year Summer Summer1 Summer2].freeze
  TERM_CREDITS = %w[1 3 4 6 9].freeze
  SUBJECTS ||= IO.readlines("#{Rails.root}/lib/course_subjects.txt").collect(&:strip)

  attr_accessor :code

  # VALIDATIONS

  validates_presence_of :year, :faculty, :subject, :term, :credits, :section, :course_id
  validates_presence_of :course_id, message: 'Course Number is required'
  validates :code, format: { without: /\s/ }
  validates_numericality_of :course_id, message: 'Course Number must be a number'
  validates_numericality_of :year, message: 'Year must be a number'
  validates_numericality_of :credits, message: 'Credits must be a number'

  def initialize(attrs = nil)
    unless attrs.nil?
      self.year = attrs[:year]
      self.faculty = attrs[:faculty]
      self.subject = attrs[:subject]
      self.term = attrs[:term]
      self.credits = attrs[:credits]
      self.section = attrs[:section]
      self.course_id = attrs[:course_id]
    end
  end

  # SPECIAL ACCESSORS TO BREAK UP THE CODE

  def year
    get_value_from_code(0)
  end

  def year=(year)
    puts "inserting into year #{year}"
    insert_into_code(0, year)
  end

  def faculty
    get_value_from_code(1)
  end

  def faculty=(faculty)
    insert_into_code(1, faculty)
  end

  def subject
    get_value_from_code(2)
  end

  def subject=(subject)
    insert_into_code(2, subject)
  end

  def term
    get_value_from_code(3)
  end

  def term=(term)
    insert_into_code(3, term)
  end

  def course_id
    get_value_from_code(4)
  end

  def course_id=(course_id)
    insert_into_code(4, course_id)
  end

  def credits
    get_value_from_code(6)
  end

  def credits=(credits)
    insert_into_code(6, credits)
  end

  def section
    get_value_from_code(7)
  end

  def section=(section)
    insert_into_code(7, section)
  end

  ####### HELPER METHODS #########

  def get_value_from_code(position)
    self.code = '_______'   if code.blank?
    code.split('_')[position]
  end

  def insert_into_code(position, value)
    self.code = '_______'   if code.blank?
    broken = code.split('_')
    broken[position] = value
    self.code = broken.join('_')
  end
end
