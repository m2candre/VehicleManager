class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
      if user.admin?
        can :manage, :all
      elsif user.supervisor?
        can :manage, [Vehicle, VehicleAssignment, VehicleService, WeeklyReport]
        can :manage, User, :id => user.id
        can :read, User
        cannot :destroy, WeeklyReport
        cannot :destroy, WeeklyReport
      elsif user.driver?
        can :manage, User, :id => user.id
        can :read, User, :id => user.id
        cannot :index, User
        
        vehicle_assignment = VehicleAssignment.where("user_id = ?", user.id)
        vehicle_assignment.each do |va|
          can [:read, :update], Vehicle, :id => va.vehicle_id
          cannot :index, Vehicle
        end
        can :create, WeeklyReport
        can [:read, :update], WeeklyReport, :user_id => user.id
        cannot :index, WeeklyReport
        cannot :destroy, WeeklyReport
      end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
