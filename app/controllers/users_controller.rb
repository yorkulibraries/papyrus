class UsersController < ApplicationController
  authorize_resource


  def inactive
    @users = User.inactive.not_students.all
  end
  
  def activate
    @user = User.find(params[:id])
    @user.inactive = false
    @user.save
    redirect_to users_path, notice: "#{@user.name} is now active in Papyrus"
  end

  def index
    @users = User.active.not_students.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to users_path, notice: "Successfully created user."
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to users_path, notice: "Successfully updated user."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.inactive = true
    @user.save
    redirect_to users_url, :notice => "Successfully disabled this user."
  end
end
