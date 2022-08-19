class TodoItem < ApplicationRecord
  # Fields: :summary, :item_id, :todo_list_id, :assigned_to_id, :created_by_id, :due_date, :status

  ## RELATIONS
  belongs_to :created_by, class_name: 'User'
  belongs_to :assigned_to, class_name: 'User'
  belongs_to :item, optional: true
  belongs_to :todo_list, class_name: 'TodoList'

  ## AUDIT TRAIL
  audited associated_with: :todo_list

  ## CONSTANTS
  STATUS_NEW = 'new'
  STATUS_DONE = 'done'

  SCAN_STATUSES = [STATUS_NEW, STATUS_DONE]

  ## VALIDATIONS
  validates_presence_of :status, :created_by, :todo_list

  ## SCOPES
  scope :completed, -> { where(status: STATUS_DONE) }
  scope :not_completed, -> { where('status <> ? ', STATUS_DONE) }

  ## METHODS
  def assignee
    if assigned_to.nil?
      'Unassigned'
    else
      assigned_to.name
    end
  end

  def creator
    if self[:created_by_id].nil?
      'System'
    else
      created_by.name
    end
  end

  def self.assignees(include_empty_field = false)
    list = User.active.not_students.collect { |u| [u.id, u.name] }
    list.unshift(['', '- Unassigned -']) if include_empty_field
  end
end
