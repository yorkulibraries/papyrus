class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    if user.role == User::ADMIN
      can :manage, :all
    elsif user.role == User::MANAGER
      can :perma_destroy, :student
      can :show, :dashboard
      can :manage, [Announcement, AcquisitionRequest]

      can :manage, Document

      can :manage, [Item, Student, Attachment, ItemConnection, User, Note, Term, Course, ScanList, ScanItem]
      can :show, :stats

      can :manage, :shared_access_codes

      can :login_as, :student

    elsif user.role == User::COORDINATOR
      can :show, :dashboard
      can :show, :stats

      can :manage, [ScanList, Document, ScanItem]
      can :manage, [Term, Course]
      can :manage, AcquisitionRequest
      can :manage, AccessCode
      can [:read, :create, :update], [Note]
      can :manage, [Item, Attachment, ItemConnection]
      can [:read, :create, :update, :items, :notify, :send_welcome_email, :audit_trail, :reactivate, :inactive, :destroy], Student
      can :login_as, :student

      can :manage, :shared_access_codes

    elsif user.role == User::STAFF
      can :show, :dashboard

      can :manage, Document do |d|
        d.user_id == user.id
      end

      can :read, Document

      can :manage, [ScanList, ScanItem]
      can :manage, [Term, Course]
      can [:read, :create, :status, :send_to_acquisitions], AcquisitionRequest
      can :manage, AccessCode
      can [:read, :create, :update], [Note]
      can :manage, [Item, Attachment, ItemConnection]
      can [:read, :create, :update, :items, :notify, :send_welcome_email, :audit_trail, :reactivate, :inactive, :destroy], Student
      can :login_as, :student

      can :manage, :shared_access_codes

    elsif user.role == User::PART_TIME
      can :show, :dashboard

      can [:create, :read, :update], [Item, Note, Course, ScanList, ScanItem]
      can [:assign_to_students, :assign_many_to_student, :withhold_from_student, :courses], Item
      can [:assign_to_item, :add_item, :remove_item], Course
      can :manage, ItemConnection
      can :read,  [Student, Term, Course, ScanList, ScanItem]
      can :login_as, :student
      can :create, Attachment
      can :get_file, Attachment
    elsif user.role == User::STUDENT_VIEW
      can :show, :dashboard
      can :read, Student
    else
      can :show, :student
      can :hide, Announcement
      can :zipped_files, Item
      can :get_file, Attachment
    end

    can :hide, Announcement

    # global search
    can [:search, :search_courses], :all

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
