# frozen_string_literal: true

class UsersController < AuthenticatedController
  authorize_resource

  def inactive
    @users = User.blocked.not_students.to_a
  end

  def activate
    @user = User.find(params[:id])
    @user.blocked = false
    @user.audit_comment = 'Activated User Account'
    @user.save(validate: false)
    redirect_to users_path, notice: "#{@user.name} is now active in Papyrus"
  end

  def index
    @users = User.unblocked.not_students.to_a
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
      redirect_to users_path, notice: 'Successfully created user.'
    else
      render action: 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def audit_trail
    @user = User.not_students.find(params[:id])

    @start_year = Audited::Audit.where(user_id: @user.id).first.created_at.year
    @end_year = Audited::Audit.where(user_id: @user.id).last.created_at.year

    @current_year = params[:year] || Date.today.year

    @audits = Audited::Audit.where('user_id = ? OR (auditable_id = ? AND auditable_type = ?)', @user.id, @user.id, 'User')
                            .where('created_at >= ? AND created_at <= ?', "#{@current_year}-01-01", "#{@current_year}-12-31")
                            .order(:created_at)

    # @audits.sort! { |a, b| a.created_at <=> b.created_at } # not used here

    @audits_grouped = @audits.reverse.group_by { |a| a.created_at.at_beginning_of_day }
  end

  def update
    @user = User.find(params[:id])
    @user.audit_comment = 'Updated User Details'
    if @user.update(user_params)
      redirect_to users_path, notice: 'Successfully updated user.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.blocked = true
    @user.audit_comment = 'Blocked User Account'
    @user.save(validate: false)
    redirect_to users_url, notice: 'Successfully disabled this user.'
  end

  private

  def user_params
    if Rails.configuration.is_using_login_password_authentication
      params.require(:user).permit(:username, :first_name, :last_name, :role, :email, :password)
    else
      params.require(:user).permit(:username, :first_name, :last_name, :role, :email)
    end
  end
end
