class UsersController < ApplicationController
  authorize_resource


  def inactive
    @users = User.inactive.not_students.to_a
  end

  def activate
    @user = User.find(params[:id])
    @user.inactive = false
    @user.audit_comment = "Activated User Account"
    @user.save
    redirect_to users_path, notice: "#{@user.name} is now active in Papyrus"
  end

  def index
    @users = User.active.not_students.to_a
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "Successfully created user."
    else
      render action: 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def audit_trail
    @user = User.not_students.find(params[:id])
    @audits = @user.audits
    @audits.sort! { |a, b| a.created_at <=> b.created_at }

    @audits_grouped = @audits.reverse.group_by { |a| a.created_at.at_beginning_of_day }
  end

  def update
    @user = User.find(params[:id])
    @user.audit_comment = "Updated User Details"
    if @user.update_attributes(user_params)
      redirect_to users_path, notice: "Successfully updated user."
    else
      render action: 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.inactive = true
    @user.audit_comment = "Deactivated User Account"
    @user.save
    redirect_to users_url, notice: "Successfully disabled this user."
  end

  private
  def user_params
      params.require(:user).permit(  :username, :first_name, :last_name, :role, :email)
  end

end
