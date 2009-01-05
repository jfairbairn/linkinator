class Admin::UsersController < ApplicationController
  before_filter :admin_login_required
  layout 'default'

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to admin_users_url
    else
      render :action => 'new'
    end
  end
  
  def show
    @user = User.find(:first, :conditions => ['id=?',params[:id]]) or return not_found
  end
  
  def update
    @user = User.find(:first, :conditions => ['id=?',params[:id]]) or return not_found
    
    if @user.update_attributes(params[:user])
      redirect_to admin_users_url
    else
      render :action => 'show'
    end
  end
  
  def destroy
    @user = User.find(:first, :conditions => ['id=?',params[:id]]) or return not_found
    return not_found if @user == current_user
    @user.destroy
    redirect_to admin_users_url
  end
  
  def index
    @users = User.find(:all, :order => 'login')
  end
  
end
